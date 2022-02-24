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


ARG BUILD_FROM
FROM $BUILD_FROM

#Add nginx and create the run folder for nginx.
RUN \
  apk --no-cache add \
    nginx \
  \
  && mkdir -p /run/nginx

#Copy our conf into the nginx http.d folder.
COPY ingress.conf /etc/nginx/http.d/

#Launch nginx with debug options.
CMD [ "nginx","-g","daemon off;error_log /dev/stdout debug;" ]