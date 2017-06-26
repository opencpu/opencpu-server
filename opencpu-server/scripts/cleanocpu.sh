#!/bin/bash

#This script removes all tempfiles that are over an hour old
if [ -d "/tmp/ocpu-temp" ]; then
    find /tmp/ocpu-temp/ -mindepth 1 -mmin +60 -user www-data -delete || true
    find /tmp/ocpu-temp/ -mindepth 1 -mmin +60 -user www-data -type d -empty -exec rmdir {} \; || true
fi

#This removes entries from the "temporary library" over a day old.
if [ -d "/tmp/ocpu-store" ]; then
    find /tmp/ocpu-store/ -mindepth 1 -mmin +1440 -user www-data -delete || true
    find /tmp/ocpu-store/ -mindepth 1 -mmin +1440 -user www-data -type d -empty -exec rmdir {} \; || true
fi
