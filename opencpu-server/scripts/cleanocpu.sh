#!/bin/bash

#This script removes all tempfiles that are over an hour old
find /tmp/ocpu-temp/ -mindepth 1 -mmin +60 -user www-data -delete || true
find /tmp/ocpu-temp/ -mindepth 1 -mmin +60 -user www-data -type d -empty -exec rmdir {} \; || true

#This removes entries from the "temporary library" over a day old.
find /tmp/ocpu-www-data/tmp_library/ -mindepth 1 -mmin +1440 -user www-data -delete || true
find /tmp/ocpu-www-data/tmp_library/ -mindepth 1 -mmin +1440 -user www-data -type d -empty -exec rmdir {} \; || true
