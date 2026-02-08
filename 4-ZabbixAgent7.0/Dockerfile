FROM zabbix/zabbix-agent:alpine-7.0-latest

USER root

RUN apk add --no-cache jq

COPY run.sh /run.sh
RUN chmod 755 /run.sh

ENTRYPOINT ["/run.sh"]
