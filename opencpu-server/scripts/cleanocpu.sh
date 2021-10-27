#!/bin/bash

ls /tmp | grep apache2.service > work.txt
temp="/tmp/$(cat work.txt)/tmp/ocpu-temp"
store="/tmp/$(cat work.txt)/tmp/ocpu-store"

#This script removes all tempfiles that are over an hour old
if [ -d "$temp" ]; then
    find $temp -mindepth 1 -mmin +60 -user www-data -delete || true
    find $temp -mindepth 1 -mmin +60 -user www-data -type d -empty -exec rmdir {} \; || true
fi

#This removes entries from the "temporary library" over a day old.
if [ -d "$store" ]; then
    find $store -mindepth 1 -mmin +1440 -user www-data -delete || true
    find $store -mindepth 1 -mmin +1440 -user www-data -type d -empty -exec rmdir {} \; || true
fi
