#!/usr/bin/env ash

# Extract config data
CONFIG_PATH=/data/options.json
ZABBIX_SERVER=$(jq --raw-output ".server" "$CONFIG_PATH")
ZABBIX_HOSTNAME=$(jq --raw-output ".hostname" "$CONFIG_PATH")
NAME_SERVER=$(jq --raw-output ".nameserver" "$CONFIG_PATH")

echo 12c8d3be3ed7284614e0a1c7f33b74e4 > "/etc/zabbix/zabbix_agent.psk"

# Update zabbix-agent config
ZABBIX_CONFIG_FILE=/etc/zabbix/zabbix_agentd.conf

echo "Hostname=${ZABBIX_HOSTNAME}" >> "${ZABBIX_CONFIG_FILE}"
echo "LogFile=/var/log/zabbix/zabbix_agentd.log" >> "${ZABBIX_CONFIG_FILE}"
echo "Server=${ZABBIX_SERVER}" >> "${ZABBIX_CONFIG_FILE}"
echo "ServerActive=${ZABBIX_SERVER}" >> "${ZABBIX_CONFIG_FILE}"
echo "TLSAccept=psk" >> "${ZABBIX_CONFIG_FILE}"
echo "TLSConnect=psk" >> "${ZABBIX_CONFIG_FILE}"
echo "TLSPSKIdentity=PSK001" >> "${ZABBIX_CONFIG_FILE}"
echo "TLSPSKFile=/etc/zabbix/zabbix_agent.psk" >> "${ZABBIX_CONFIG_FILE}"

# aggiunta dns
echo "nameserver ${NAME_SERVER}" > "/etc/resolv.conf"

# Run zabbix-agent2 in foreground
exec su zabbix -s /bin/ash -c "zabbix_agentd -f"
