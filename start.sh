#!/bin/bash

# Start the varnish daemon
varnishd -f /etc/varnish/default.vcl \
  -s malloc,${VARNISH_MALLOC} \
  -a 0.0.0.0:${VARNISH_PORT}

# TODO Send logging to a specific log file...
varnishlog
