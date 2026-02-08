#!/bin/sh

echo "Starting Zabbix Agent 7 Add-on"

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
DNS_SERVER=$(jq -r '.dns_server' $CONFIG_FILE)

echo "Configuration:"
echo "  Server: $SERVER"
echo "  Server Active: $SERVER_ACTIVE"
echo "  Hostname: $HOSTNAME"

if [ "$DNS_SERVER" != "null" ] && [ ! -z "$DNS_SERVER" ]; then
  echo "Overriding DNS to $DNS_SERVER"
  echo "nameserver $DNS_SERVER" > /etc/resolv.conf
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
