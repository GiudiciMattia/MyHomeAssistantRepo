#!/bin/sh

set -e

echo "=== Zabbix Agent 7 Add-on Startup ==="

CONFIG_FILE="/data/options.json"

if [ ! -f "$CONFIG_FILE" ]; then
  echo "ERROR: $CONFIG_FILE not found!"
  exit 1
fi

SERVER=$(jq -r '.server' "$CONFIG_FILE")
SERVER_ACTIVE=$(jq -r '.server_active' "$CONFIG_FILE")
HOSTNAME=$(jq -r '.hostname' "$CONFIG_FILE")
PSK_IDENTITY=$(jq -r '.psk_identity' "$CONFIG_FILE")
PSK_SECRET=$(jq -r '.psk_secret' "$CONFIG_FILE")

echo "Loaded configuration:"
echo "  Server: $SERVER"
echo "  Server Active: $SERVER_ACTIVE"
echo "  Hostname: $HOSTNAME"

if [ -z "$SERVER" ] || [ -z "$SERVER_ACTIVE" ] || [ -z "$HOSTNAME" ]; then
  echo "ERROR: server, server_active, hostname are mandatory"
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

  cat <<EOF >> $CONF
TLSConnect=psk
TLSAccept=psk
TLSPSKIdentity=$PSK_IDENTITY
TLSPSKFile=/etc/zabbix/psk.key
EOF

  echo "$PSK_SECRET" > /etc/zabbix/psk.key
  chmod 600 /etc/zabbix/psk.key
fi

echo "Final configuration:"
cat $CONF

echo "Starting Zabbix agent..."

exec zabbix_agentd -f -c $CONF
