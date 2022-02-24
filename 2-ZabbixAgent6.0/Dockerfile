ARG BUILD_FROM
FROM $BUILD_FROM

# Install requirements for add-on
# Install requirements for add-on
RUN apk add --no-cache jq zabbix-agent2 && \
    addgroup -g 1003 docker && \
    addgroup zabbix docker

WORKDIR /data

# Copy data for add-on
COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]