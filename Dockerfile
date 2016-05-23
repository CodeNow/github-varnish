FROM ubuntu:12.04
ENV DEBIAN_FRONTEND noninteractive

#RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN apt-get -qq update
RUN apt-get install -y varnish vim git

# Default environment configuration (see start.sh)
ENV VARNISH_PORT 80
ENV VARNISH_MALLOC 100M

# Add repository defined VCL
ADD default.vcl /etc/varnish/default.vcl

ADD start.sh /start.sh
RUN chmod 0755 /start.sh

EXPOSE 80
CMD ["/start"]
