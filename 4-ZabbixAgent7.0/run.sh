#!/bin/sh

echo "=== Zabbix Agent 7 Add-on Startup ==="

CONFIG_FILE="/data/options.json"

if [ ! -f "$CONFIG_FILE" ]; then
  echo "ERROR: options.json not found!"
  exit 1
fi

OPTIONS=$(cat $CONFIG_FILE)

SERVER=$(echo "$OPTIONS" | jq -r '.server')
SERVER_ACTIVE=$(echo "$OPTIONS" | jq -r '.server_active')
HOSTNAME=$(echo "$OPTIONS" | jq -r '.hostname')
PSK_IDENTITY=$(echo "$OPTIONS" | jq -r '.psk_identity')
PSK_SECRET=$(echo "$OPTIONS" | jq -r '.psk_secret')
DNS_SERVER=$(echo "$OPTIONS" | jq -r '.dns_server')

echo "Loaded configuration:"
echo "  Server: $SERVER"
echo "  Server Active: $SERVER_ACTIVE"
echo "  Hostname: $HOSTNAME"

# DNS override se richiesto
if [ -n "$DNS_SERVER" ] && [ "$DNS_SERVER" != "null" ]; then
  echo "Overriding DNS to $DNS_SERVER"
  echo "nameserver $DNS_SERVER" > /etc/resolv.conf
fi

# Impostazione variabili ufficiali Zabbix
export ZBX_SERVER_HOST="$SERVER"
export ZBX_ACTIVESERVERS="$SERVER_ACTIVE"
export ZBX_HOSTNAME="$HOSTNAME"

if [ -n "$PSK_IDENTITY" ] && [ -n "$PSK_SECRET" ] && [ "$PSK_IDENTITY" != "null" ]; then
  echo "Enabling TLS PSK authentication"

  export ZBX_TLSCONNECT="psk"
  export ZBX_TLSACCEPT="psk"
  export ZBX_TLSPSKIDENTITY="$PSK_IDENTITY"
  export ZBX_TLSPSK="$PSK_SECRET"
else
  echo "TLS PSK not configured - running without encryption"
fi

echo "Environment variables prepared:"
env | grep ZBX

echo "Starting official Zabbix entrypoint..."

# Qui deleghiamo tutto al docker-entrypoint originale
exec /usr/bin/docker-entrypoint.sh
