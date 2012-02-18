#!/bin/sh

# Run a root

# Copy in starman init
cp etc/init.d/starman /etc/init.d/

# Make sure it runs at startup
/usr/sbin/update-rc.d starman defaults 18

# 