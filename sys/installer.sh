#!/bin/sh

# Run as root - manually probably easier than this script

# Installing varnish:
echo "To install varnish see:"
echo "https://www.varnish-cache.org/installation/debian"
echo "replace $(lsb_release -s -c) with: squeeze"

# Copy in starman init
cp -r etc/* /etc/

# Make sure it runs at startup
/usr/sbin/update-rc.d starman defaults 18

