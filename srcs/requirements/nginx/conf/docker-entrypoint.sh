#!/bin/sh

envsubst '${DOMAIN_NAME}' < /etc/nginx/http.d/nginx.conf.template \
  > /etc/nginx/http.d/nginx.conf

exec "$@"