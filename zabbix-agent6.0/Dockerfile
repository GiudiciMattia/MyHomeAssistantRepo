ARG BUILD_FROM
FROM $BUILD_FROM

ARG BUILD_ARCH
ARG BUILD_VERSION

LABEL maintainer "Mattia Giudici <mattia.giudici@outlook.com>"

ENV LANG C.UTF-8

# Install requirements for add-on
RUN apk add --no-cache jq zabbix-agent2 && \
    apk add --no-cache mc && \
    apk add --no-cache nmap && \
    addgroup -g 1003 docker && \
    addgroup zabbix docker

# Copy data for add-on
COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
