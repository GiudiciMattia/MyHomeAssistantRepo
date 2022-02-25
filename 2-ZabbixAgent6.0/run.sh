#!/usr/bin/env ash

# Extract config data
CONFIG_PATH=/data/options.json
ZABBIX_REMCOMM=$(jq --raw-output ".EnableRemoteCommands" "$CONFIG_PATH")
ZABBIX_SERVER=$(jq --raw-output ".server" "$CONFIG_PATH")
ZABBIX_SERVERACTIVE=$(jq --raw-output ".server_active" "$CONFIG_PATH")
ZABBIX_HOSTNAME=$(jq --raw-output ".hostname" "$CONFIG_PATH")
ZABBIX_STARTAGENT=$(jq --raw-output ".StartAgents" "$CONFIG_PATH")
ZABBIX_REFRESHACTIVECHECKS=$(jq --raw-output ".RefreshActiveChecks" "$CONFIG_PATH")
ZABBIX_BUFFERSEND=$(jq --raw-output ".BufferSend" "$CONFIG_PATH")
ZABBIX_BUFFERSIZE=$(jq --raw-output ".BufferSize" "$CONFIG_PATH")
ZABBIX_TIMEOUT=$(jq --raw-output ".Timeout" "$CONFIG_PATH")

ZABBIX_TLSCONNECT=$(jq --raw-output ".TLSConnect" "$CONFIG_PATH")
ZABBIX_TLSACCEPT=$(jq --raw-output ".TLSAccept" "$CONFIG_PATH")
ZABBIX_TLSPSKIDENTITY=$(jq --raw-output ".TLSPSKIdentity" "$CONFIG_PATH")
ZABBIX_TLSPSKCODE=$(jq --raw-output ".TLSPSKCode" "$CONFIG_PATH")

ZABBIX_PSKKEYFILE="/etc/zabbix/zabbix_agent.psk"
echo ${ZABBIX_TLSPSKCODE} > "/etc/zabbix/zabbix_agent.psk"

# Update zabbix-agent config
ZABBIX_CONFIG_FILE=/etc/zabbix/zabbix_agentd.conf

echo "EnableRemoteCommands=$ZABBIX_REMCOMM" >> "${ZABBIX_CONFIG_FILE}"
echo "Server=$ZABBIX_SERVER" >> "${ZABBIX_CONFIG_FILE}"
echo "ServerActive=$ZABBIX_SERVERACTIVE" >> "${ZABBIX_CONFIG_FILE}"
echo "Hostname=$ZABBIX_HOSTNAME" >> "${ZABBIX_CONFIG_FILE}"
echo "StartAgents=$ZABBIX_STARTAGENT" >> "${ZABBIX_CONFIG_FILE}"
echo "RefreshActiveChecks=$ZABBIX_REFRESHACTIVECHECKS" >> "${ZABBIX_CONFIG_FILE}"
echo "BufferSend=$ZABBIX_BUFFERSEND" >> "${ZABBIX_CONFIG_FILE}"
echo "BufferSize=$ZABBIX_BUFFERSIZE" >> "${ZABBIX_CONFIG_FILE}"
echo "Timeout=$ZABBIX_TIMEOUT" >> "${ZABBIX_CONFIG_FILE}"
echo "TLSAccept=psk" >> "${ZABBIX_CONFIG_FILE}"
echo "TLSConnect=psk" >> "${ZABBIX_CONFIG_FILE}"
echo "TLSPSKIdentity=PSK001" >> "${ZABBIX_CONFIG_FILE}"
echo "TLSPSKFile=/etc/zabbix/zabbix_agent.psk" >> "${ZABBIX_CONFIG_FILE}"
echo "LogFile=/var/log/zabbix/zabbix_agentd.log" >> "${ZABBIX_CONFIG_FILE}"

# Run zabbix-agent2 in foreground
exec su zabbix -s /bin/ash -c "zabbix_agentd -f"
