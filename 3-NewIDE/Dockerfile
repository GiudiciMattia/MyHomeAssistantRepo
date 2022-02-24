# ARG BUILD_FROM
# FROM $BUILD_FROM

# # Install requirements for add-on
# RUN \
#   apk add --no-cache \
#     python3

# # Python 3 HTTP Server serves the current working dir
# # So let's set it to our add-on persistent data directory.
# WORKDIR /data

# # Copy data for add-on
# COPY run.sh /
# RUN chmod a+x /run.sh

# CMD [ "/run.sh" ]

######################################################################################
# ARG BUILD_FROM
# FROM $BUILD_FROM

# #Add nginx and create the run folder for nginx.
# RUN \
#   apk --no-cache add \
#     nginx \
#   \
#   && mkdir -p /run/nginx

# #Copy our conf into the nginx http.d folder.
# COPY ingress.conf /etc/nginx/http.d/

# #Launch nginx with debug options.
# CMD [ "nginx","-g","daemon off;error_log /dev/stdout debug;" ]

# ------------------------------------------------------------------------------
# Thanks to https://github.com/tghastings/cloud9-docker
# ------------------------------------------------------------------------------
# Pull base image


#FROM alpine:3.8
ARG BUILD_FROM
FROM $BUILD_FROM

# ------------------------------------------------------------------------------
# Install base and clean up
RUN apk --update add build-base bash \
	  curl g++ git make nodejs nodejs-npm python2 tmux && \
	rm -f /var/cache/apk/*

# ------------------------------------------------------------------------------
# Install Cloud9 and clean up
RUN git clone https://github.com/c9/core.git /c9 && cd /c9 && \
	curl -s https://raw.githubusercontent.com/c9/install/master/link.sh \
	  -o scripts/link.sh && chmod +x scripts/link.sh && \
	./scripts/link.sh && \
	./scripts/install-sdk.sh && \
	rm -rf /c9/.git /root/.c9/tmp /root/.npm /root/.node-gyp

# ------------------------------------------------------------------------------
# Add app.sh
COPY app.sh /app/

# ------------------------------------------------------------------------------
# Add volumes
VOLUME /log
VOLUME /c9ws

# ------------------------------------------------------------------------------
# Expose ports
EXPOSE 80

# ------------------------------------------------------------------------------
# Define default command
CMD ["/app/app.sh"]