#!/bin/sh

echo "Starting Zabbix Agent 7 Add-on"

CONFIG_FILE="/data/options.json"

if [ ! -f "$CONFIG_FILE" ]; then
  echo "ERROR: options.json not found!"
  exit 1
fi

# Lettura file come root tramite su
OPTIONS=$(su -c "cat $CONFIG_FILE")

SERVER=$(echo "$OPTIONS" | jq -r '.server')
SERVER_ACTIVE=$(echo "$OPTIONS" | jq -r '.server_active')
HOSTNAME=$(echo "$OPTIONS" | jq -r '.hostname')
PSK_IDENTITY=$(echo "$OPTIONS" | jq -r '.psk_identity')
PSK_SECRET=$(echo "$OPTIONS" | jq -r '.psk_secret')
DNS_SERVER=$(echo "$OPTIONS" | jq -r '.dns_server')

echo "Configuration:"
echo "  Server: $SERVER"
echo "  Server Active: $SERVER_ACTIVE"
echo "  Hostname: $HOSTNAME"

if [ "$DNS_SERVER" != "null" ] && [ ! -z "$DNS_SERVER" ]; then
  echo "Overriding DNS to $DNS_SERVER"
  su -c "echo \"nameserver $DNS_SERVER\" > /etc/resolv.conf"
fi

export ZBX_SERVER_HOST="$SERVER"
export ZBX_ACTIVESERVERS="$SERVER_ACTIVE"
export ZBX_HOSTNAME="$HOSTNAME"

if [ "$PSK_IDENTITY" != "null" ] && [ ! -z "$PSK_IDENTITY" ] && [ "$PSK_SECRET" != "null" ] && [ ! -z "$PSK_SECRET" ]; then
  echo "Enabling TLS PSK authentication"

  export ZBX_TLSCONNECT="psk"
  export ZBX_TLSACCEPT="psk"
  export ZBX_TLSPSKIDENTITY="$PSK_IDENTITY"
  export ZBX_TLSPSK="$PSK_SECRET"
else
  echo "TLS PSK not configured"
fi

echo "Environment prepared:"
env | grep ZBX

echo "Launching Zabbix Agent..."

exec /usr/sbin/zabbix_agentd --foreground
