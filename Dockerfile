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
RUN sed -i s/{GITHUB_DOMAIN}/${GITHUB_DOMAIN}/ /etc/nginx/sites-available/default
RUN sed -i s/{GITHUB_PROTOCOL}/${GITHUB_PROTOCOL}/ /etc/nginx/sites-available/default
RUN if $IS_GITHUB_ENTERPRISE; then sed -i 's/#GITHUB_ENTERPRISE_REWRITE //' /etc/nginx/sites-available/default; fi

# Expose the port and start the proxies
EXPOSE 80
CMD ["/start.sh"]
