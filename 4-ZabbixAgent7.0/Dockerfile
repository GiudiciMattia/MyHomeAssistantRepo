FROM zabbix/zabbix-agent:alpine-7.0-latest

# Passiamo temporaneamente a root per installare dipendenze
USER root

RUN apk add --no-cache jq

# Torniamo subito all’utente originale dell’immagine


COPY run.sh /run.sh
RUN chmod +x /run.sh

USER zabbix

ENTRYPOINT ["/run.sh"]
