#!/bin/bash

# Fail fast if any command fails
set -e

sed -i s/{GITHUB_DOMAIN}/${GITHUB_DOMAIN}/ /etc/nginx/sites-available/default
sed -i s/{GITHUB_PROTOCOL}/${GITHUB_PROTOCOL}/ /etc/nginx/sites-available/default
if $IS_GITHUB_ENTERPRISE; then sed -i 's/#GITHUB_ENTERPRISE_REWRITE //' /etc/nginx/sites-available/default; fi

# Start nginx
service nginx start

# Start the varnish daemon
varnishd -f /etc/varnish/default.vcl \
  -s malloc,${VARNISH_MALLOC} \
  -a 0.0.0.0:${VARNISH_PORT}

# Show only Varnish errors
varnishlog -I "Error"
