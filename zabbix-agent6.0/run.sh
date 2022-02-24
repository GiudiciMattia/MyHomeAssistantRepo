#!/usr/bin/env ash

# Extract config data
CONFIG_PATH=/data/options.json
ZABBIX_SERVER=$(jq --raw-output ".server" "$CONFIG_PATH")
ZABBIX_HOSTNAME=$(jq --raw-output ".hostname" "$CONFIG_PATH")

ZABBIX_TLSCONNECT=$(jq --raw-output ".TLSConnect" "$CONFIG_PATH")
ZABBIX_TLSACCEPT=$(jq --raw-output ".TLSAccept" "$CONFIG_PATH")
ZABBIX_TLSPSKIDENTITY=$(jq --raw-output ".TLSPSKIdentity" "$CONFIG_PATH")
ZABBIX_TLSPSKKEY=$(jq --raw-output ".TLSPSKKey" "$CONFIG_PATH")

echo $ZABBIX_TLSPSKKEY > /etc/zabbix/zabbix_agent.psk

# Update zabbix-agent config
ZABBIX_CONFIG_FILE=/etc/zabbix/zabbix_agent2.conf
sed -i 's@^#\?\s\?\(Server\(Active\)\?\)=.*@\1='"${ZABBIX_SERVER}"'@' "$ZABBIX_CONFIG_FILE"
sed -i 's/^#\?\s\?\(Hostname\)=.*$/\1='"${ZABBIX_HOSTNAME}"'/' "${ZABBIX_CONFIG_FILE}"

sed -i 's@^#\?\s\?\(TLSConnect\(Active\)\?\)=.*@\1='"${ZABBIX_TLSCONNECT}"'@' "$ZABBIX_CONFIG_FILE"
sed -i 's/^#\?\s\?\(TLSAccept\)=.*$/\1='"${ZABBIX_TLSACCEPT}"'/' "${ZABBIX_CONFIG_FILE}"
sed -i 's@^#\?\s\?\(TLSPSKIdentity\(Active\)\?\)=.*@\1='"${ZABBIX_TLSPSKIDENTITY}"'@' "$ZABBIX_CONFIG_FILE"
sed -i 's/^#\?\s\?\(TLSPSKFile\)=.*$/\1='"/etc/zabbix/zabbix_agent.psk"'/' "${ZABBIX_CONFIG_FILE}"

# Run zabbix-agent2 in foreground
exec su zabbix -s /bin/ash -c "zabbix_agent2 -f"

