#!/usr/bin/env ash

# Extract config data
CONFIG_PATH=/data/options.json
ZABBIX_SERVER=$(jq --raw-output ".server" "$CONFIG_PATH")
ZABBIX_HOSTNAME=$(jq --raw-output ".hostname" "$CONFIG_PATH")

ZABBIX_TLSCONNECT=$(jq --raw-output ".TLSConnect" "$CONFIG_PATH")
ZABBIX_TLSACCEPT=$(jq --raw-output ".TLSAccept" "$CONFIG_PATH")
ZABBIX_TLSPSKIDENTITY=$(jq --raw-output ".TLSPSKIdentity" "$CONFIG_PATH")
ZABBIX_TLSPSKCODE=$(jq --raw-output ".TLSPSKCode" "$CONFIG_PATH")
ZABBIX_PSKKEYFILE="/etc/zabbix/zabbix_agent.psk"

echo ${ZABBIX_TLSPSKCODE} > "/etc/zabbix/zabbix_agent.psk"

# Update zabbix-agent config
ZABBIX_CONFIG_FILE=/etc/zabbix/zabbix_agentd.conf


# # # EnableRemoteCommands=1

# # # ##### Passive checks related
# # # Server=zabbix-proxy-1.winsite.mshome.local

# # # ### Option: ListenPort
# # # ListenPort=10050

# # # ### Option: ListenIP
# # # ListenIP=0.0.0.0

# # # ### Option: StartAgents
# # # StartAgents=3

# # # ### Option: ServerActive
# # # ServerActive=zabbix-proxy-1.winsite.mshome.local

# # # ### Option: Hostname
# # # Hostname=DCBSX001.winsite.mshome.local

# # # ### Option: RefreshActiveChecks
# # # RefreshActiveChecks=120

# # # ### Option: BufferSend
# # # BufferSend=5

# # # ### Option: BufferSize
# # # BufferSize=100

# # # ### Option: Timeout
# # # Timeout=3

# # # TLSConnect=psk
# # # TLSAccept=psk
# # # TLSPSKIdentity=PSK001
# # # TLSPSKFile=/etc/zabbix/zabbix_agent.psk











# sed -i 's@^#\?\s\?\(Server\(Active\)\?\)=.*@\1='"${ZABBIX_SERVER}"'@' "$ZABBIX_CONFIG_FILE"
# sed -i 's/^#\?\s\?\(Hostname\)=.*$/\1='"${ZABBIX_HOSTNAME}"'/' "${ZABBIX_CONFIG_FILE}"
# sed -i 's/^#\?\s\?\(TLSConnect\)=.*$/\1='"${ZABBIX_TLSCONNECT}"'/' "${ZABBIX_CONFIG_FILE}"
# sed -i 's/^#\?\s\?\(TLSAccept\)=.*$/\1='"${ZABBIX_TLSACCEPT}"'/' "${ZABBIX_CONFIG_FILE}"
# echo "TLSPSKIdentity=PSK001" >> "${ZABBIX_CONFIG_FILE}"
# echo "TLSPSKFile=/etc/zabbix/zabbix_agent.psk" >> "${ZABBIX_CONFIG_FILE}"
#echo "ControlSocket=/run/zabbix/zabbix_agent2.sock" >> "${ZABBIX_CONFIG_FILE}"

echo "Hostname=srvlnxhassio01.winsite.mshome.local" >> "${ZABBIX_CONFIG_FILE}"
echo "LogFile=/var/log/zabbix/zabbix_agent2.log" >> "${ZABBIX_CONFIG_FILE}"
echo "Server=zabbix-proxy-1.winsite.mshome.local" >> "${ZABBIX_CONFIG_FILE}"
echo "ServerActive=zabbix-proxy-1.winsite.mshome.local" >> "${ZABBIX_CONFIG_FILE}"
echo "TLSAccept=psk" >> "${ZABBIX_CONFIG_FILE}"
echo "TLSConnect=psk" >> "${ZABBIX_CONFIG_FILE}"
echo "TLSPSKIdentity=PSK001" >> "${ZABBIX_CONFIG_FILE}"
echo "TLSPSKFile=/etc/zabbix/zabbix_agent.psk" >> "${ZABBIX_CONFIG_FILE}"

# Run zabbix-agent2 in foreground
exec su zabbix -s /bin/ash -c "zabbix_agentd -f"
