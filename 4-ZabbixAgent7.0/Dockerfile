FROM zabbix/zabbix-agent:alpine-7.0-latest

USER root

# Installiamo jq per leggere options.json
RUN apk add --no-cache jq

# Copiamo la struttura S6
COPY rootfs /

# Lo user sarà gestito dall'entrypoint di Zabbix

ENTRYPOINT ["sleep", "9999"]
