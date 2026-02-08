#!/bin/sh

echo "=== Zabbix Agent 7 Add-on Startup ==="

CONFIG_FILE="/data/options.json"

OPTIONS=$(cat $CONFIG_FILE)

SERVER=$(echo "$OPTIONS" | jq -r '.server')
SERVER_ACTIVE=$(echo "$OPTIONS" | jq -r '.server_active')
HOSTNAME=$(echo "$OPTIONS" | jq -r '.hostname')
PSK_IDENTITY=$(echo "$OPTIONS" | jq -r '.psk_identity')
PSK_SECRET=$(echo "$OPTIONS" | jq -r '.psk_secret')
DNS_SERVER=$(echo "$OPTIONS" | jq -r '.dns_server')

echo "Loaded configuration:"
echo "  Server: $SERVER"
echo "  Hostname: $HOSTNAME"

if [ -n "$DNS_SERVER" ]; then
  echo "Overriding DNS to $DNS_SERVER"
  echo "nameserver $DNS_SERVER" > /etc/resolv.conf
fi

echo "Starting official Zabbix entrypoint with forced environment..."

exec env \
  ZBX_SERVER_HOST="$SERVER" \
  ZBX_ACTIVESERVERS="$SERVER_ACTIVE" \
  ZBX_HOSTNAME="$HOSTNAME" \
  ZBX_TLSCONNECT="psk" \
  ZBX_TLSACCEPT="psk" \
  ZBX_TLSPSKIDENTITY="$PSK_IDENTITY" \
  ZBX_TLSPSK="$PSK_SECRET" \
  /usr/bin/docker-entrypoint.sh zabbix_agentd -f
