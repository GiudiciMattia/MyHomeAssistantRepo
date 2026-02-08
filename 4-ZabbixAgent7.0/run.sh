#!/bin/sh

set -e

echo "=== Zabbix Agent 7 Add-on Startup ==="

CONFIG_FILE="/data/options.json"

if [ ! -f "$CONFIG_FILE" ]; then
  echo "ERROR: $CONFIG_FILE not found!"
  exit 1
fi

SERVER=$(jq -r '.server // empty' "$CONFIG_FILE")
SERVER_ACTIVE=$(jq -r '.server_active // empty' "$CONFIG_FILE")
HOSTNAME=$(jq -r '.hostname // empty' "$CONFIG_FILE")
PSK_IDENTITY=$(jq -r '.psk_identity // empty' "$CONFIG_FILE")
PSK_SECRET=$(jq -r '.psk_secret // empty' "$CONFIG_FILE")

echo "Loaded configuration:"
echo "  Server: $SERVER"
echo "  Server Active: $SERVER_ACTIVE"
echo "  Hostname: $HOSTNAME"

if [ -z "$SERVER" ] || [ -z "$SERVER_ACTIVE" ] || [ -z "$HOSTNAME" ]; then
  echo "ERROR: server, server_active and hostname are mandatory"
  exit 1
fi

CONF="/etc/zabbix/zabbix_agentd.conf"

echo "Generating configuration file..."

cat <<EOF > $CONF
PidFile=/tmp/zabbix_agentd.pid
LogType=console
Server=$SERVER
ServerActive=$SERVER_ACTIVE
Hostname=$HOSTNAME
EOF

if [ -n "$PSK_IDENTITY" ] && [ -n "$PSK_SECRET" ]; then
  echo "Enabling TLS PSK"

  PSK_DIR="/var/lib/zabbix/enc"
  PSK_FILE="$PSK_DIR/psk.key"

  mkdir -p "$PSK_DIR"
  chown zabbix:zabbix "$PSK_DIR"
  chmod 750 "$PSK_DIR"

  echo "$PSK_SECRET" > "$PSK_FILE"
  chown zabbix:zabbix "$PSK_FILE"
  chmod 400 "$PSK_FILE"

  cat <<EOF >> $CONF
TLSConnect=psk
TLSAccept=psk
TLSPSKIdentity=$PSK_IDENTITY
TLSPSKFile=$PSK_FILE
EOF

else
  echo "TLS PSK not configured - running without encryption"
fi

echo "Final configuration:"
cat $CONF

echo "Starting Zabbix agent..."

exec /usr/bin/docker-entrypoint.sh zabbix_agentd -f
