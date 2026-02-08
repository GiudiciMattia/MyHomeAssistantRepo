FROM zabbix/zabbix-agent:alpine-7.0-latest

COPY run.sh /run.sh
RUN chmod +x /run.sh

ENTRYPOINT ["/run.sh"]
