FROM zabbix/zabbix-agent:7.0-alpine

RUN apk add --no-cache jq

COPY run.sh /
RUN chmod a+x /run.sh

EXPOSE 10050

HEALTHCHECK --interval=30s --timeout=5s \
  CMD zabbix_agentd -t agent.ping | grep -q "1" || exit 1

CMD ["/run.sh"]
