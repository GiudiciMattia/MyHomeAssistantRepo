#!/bin/sh

echo "=== Zabbix Agent 7 Add-on Startup ==="

CONFIG_FILE="/data/options.json"

if [ ! -f "$CONFIG_FILE" ]; then
  echo "ERROR: options.json not found!"
  exit 1
fi

SERVER=$(jq -r '.server' $CONFIG_FILE)
SERVER_ACTIVE=$(jq -r '.server_active' $CONFIG_FILE)
HOSTNAME=$(jq -r '.hostname' $CONFIG_FILE)
PSK_IDENTITY=$(jq -r '.psk_identity' $CONFIG_FILE)
PSK_SECRET=$(jq -r '.psk_secret' $CONFIG_FILE)

echo "Loaded configuration:"
echo "  Server: $SERVER"
echo "  Server Active: $SERVER_ACTIVE"
echo "  Hostname: $HOSTNAME"

if [ -z "$SERVER" ] || [ -z "$HOSTNAME" ]; then
  echo "ERROR: server and hostname are mandatory"
  exit 1
fi

echo "Launching Zabbix Agent with provided parameters..."

exec env \
  ZBX_SERVER_HOST="$SERVER" \
  ZBX_ACTIVESERVERS="$SERVER_ACTIVE" \
  ZBX_HOSTNAME="$HOSTNAME" \
  ZBX_TLSCONNECT="psk" \
  ZBX_TLSACCEPT="psk" \
  ZBX_TLSPSKIDENTITY="$PSK_IDENTITY" \
  ZBX_TLSPSK="$PSK_SECRET" \
  /usr/bin/docker-entrypoint.sh zabbix_agentd -f
