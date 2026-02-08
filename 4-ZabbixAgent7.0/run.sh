#!/bin/sh

set -e

echo "=== Zabbix Agent 7 Add-on Startup ==="

CONFIG_FILE="/data/options.json"

if [ ! -f "$CONFIG_FILE" ]; then
  echo "ERROR: $CONFIG_FILE not found!"
  exit 1
fi

# Leggiamo options.json come root (qui lo script gira come root)
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
  echo "ERROR: server, server_active, hostname are mandatory"
  exit 1
fi

# Se PSK non è valorizzato, non forziamo TLS
TLS_ENV=""
if [ -n "$PSK_IDENTITY" ] && [ -n "$PSK_SECRET" ]; then
  echo "TLS PSK enabled"
  TLS_ENV="ZBX_TLSCONNECT=psk ZBX_TLSACCEPT=psk ZBX_TLSPSKIDENTITY=$PSK_IDENTITY ZBX_TLSPSK=$PSK_SECRET"
else
  echo "TLS PSK not configured - running without encryption"
fi

echo "Starting official Zabbix entrypoint..."

# Avvio tramite entrypoint ufficiale passando env esplicite.
# Nota: docker-entrypoint.sh avvierà zabbix_agentd; noi chiediamo foreground (-f).
if [ -n "$TLS_ENV" ]; then
  exec env \
    ZBX_SERVER_HOST="$SERVER" \
    ZBX_ACTIVESERVERS="$SERVER_ACTIVE" \
    ZBX_HOSTNAME="$HOSTNAME" \
    ZBX_TLSCONNECT="psk" \
    ZBX_TLSACCEPT="psk" \
    ZBX_TLSPSKIDENTITY="$PSK_IDENTITY" \
    ZBX_TLSPSK="$PSK_SECRET" \
    /usr/bin/docker-entrypoint.sh zabbix_agentd -f
else
  exec env \
    ZBX_SERVER_HOST="$SERVER" \
    ZBX_ACTIVESERVERS="$SERVER_ACTIVE" \
    ZBX_HOSTNAME="$HOSTNAME" \
    /usr/bin/docker-entrypoint.sh zabbix_agentd -f
fi
