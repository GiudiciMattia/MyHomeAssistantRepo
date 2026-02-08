#!/usr/bin/with-contenv bashio

echo "Starting Zabbix Agent 7 Add-on"

SERVER=$(bashio::config 'server')
SERVER_ACTIVE=$(bashio::config 'server_active')
HOSTNAME=$(bashio::config 'hostname')
PSK_IDENTITY=$(bashio::config 'psk_identity')
PSK_SECRET=$(bashio::config 'psk_secret')
DNS_SERVER=$(bashio::config 'dns_server')

echo "Configuration:"
echo "  Server: $SERVER"
echo "  Server Active: $SERVER_ACTIVE"
echo "  Hostname: $HOSTNAME"

# Override DNS if specified
if [ ! -z "$DNS_SERVER" ]; then
  echo "Overriding DNS to $DNS_SERVER"
  echo "nameserver $DNS_SERVER" > /etc/resolv.conf
fi

# Impostazione variabili base Zabbix
export ZBX_SERVER_HOST="$SERVER"
export ZBX_ACTIVESERVERS="$SERVER_ACTIVE"
export ZBX_HOSTNAME="$HOSTNAME"

# Configurazione TLS PSK se valorizzata
if [ ! -z "$PSK_IDENTITY" ] && [ ! -z "$PSK_SECRET" ]; then
  echo "Enabling TLS PSK authentication"

  export ZBX_TLSCONNECT="psk"
  export ZBX_TLSACCEPT="psk"
  export ZBX_TLSPSKIDENTITY="$PSK_IDENTITY"
  export ZBX_TLSPSK="$PSK_SECRET"
else
  echo "TLS PSK not configured - running without encryption"
fi

echo "Launching Zabbix Agent..."

exec /usr/sbin/zabbix_agentd --foreground
