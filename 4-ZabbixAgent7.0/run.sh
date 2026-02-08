#!/bin/sh

set -e

echo "=== Zabbix Agent 7 Add-on Startup ==="

CONFIG_FILE="/data/options.json"
# Leggiamo options.json come root (qui lo script gira come root)
ZABBIX_SERVER=$(jq -r '.server // empty' "$CONFIG_FILE")
ZABBIX_SERVER_ACTIVE=$(jq -r '.server_active // empty' "$CONFIG_FILE")
ZABBIX_HOSTNAME=$(jq -r '.hostname // empty' "$CONFIG_FILE")
ZABBIX_PSK_IDENTITY=$(jq -r '.psk_identity // empty' "$CONFIG_FILE")
ZABBIX_PSK_PSK_SECRET=$(jq -r '.psk_secret // empty' "$CONFIG_FILE")

echo "Loaded configuration:"
echo "  Server: $SERVER"
echo "  Server Active: $SERVER_ACTIVE"
echo "  Hostname: $HOSTNAME"

# Update zabbix-agent config
ZABBIX_CONFIG_FILE=/etc/zabbix/zabbix_agentd.conf

echo "Hostname=${ZABBIX_HOSTNAME}" >> "${ZABBIX_CONFIG_FILE}"
echo "LogFile=/var/log/zabbix/zabbix_agentd.log" >> "${ZABBIX_CONFIG_FILE}"
echo "Server=${ZABBIX_SERVER}" >> "${ZABBIX_CONFIG_FILE}"
echo "ServerActive=${ZABBIX_SERVER_ACTIVE}" >> "${ZABBIX_CONFIG_FILE}"
echo "TLSAccept=psk" >> "${ZABBIX_CONFIG_FILE}"
echo "TLSConnect=psk" >> "${ZABBIX_CONFIG_FILE}"
echo "TLSPSKIdentity=${ZABBIX_PSK_IDENTITY}" >> "${ZABBIX_CONFIG_FILE}"
echo "TLSPSKFile=${ZABBIX_PSK_PSK_SECRET}" >> "${ZABBIX_CONFIG_FILE}"

# Run zabbix-agent2 in foreground
exec su zabbix -s /bin/ash -c "zabbix_agentd -f"