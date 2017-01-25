FROM ubuntu:14.04

# Install debug utilities
RUN apt-get update && apt-get install -y curl vim dnsutils

# Install and configure nginx
RUN apt-get update && apt-get install -y nginx

# Install and configure varnish
RUN apt-get -qq update && apt-get install -y varnish vim git

# Add the startup script
ADD src/start.sh /start.sh
RUN chmod 0755 /start.sh

# Set Configurations for varnish and nginx
ENV VARNISH_PORT 80
ENV VARNISH_MALLOC 100M
ADD src/default.vcl /etc/varnish/default.vcl
COPY src/nginx-https-proxy.tmpl /etc/nginx/sites-available/default

# Expose the port and start the proxies
EXPOSE 80
CMD ["/start.sh"]
