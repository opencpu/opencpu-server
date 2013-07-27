#!/bin/bash
#This script removes all tempfiles that are over an hour old
find /tmp/ocpu-temp -mmin +60 -user www-data -delete
find /tmp/ocpu-temp -mmin +60 -user www-data -type d -empty -exec rmdir {} \;

#This removes entries from the "temporary library" over a day old.
find /tmp/ocpu-www-data/tmp_library -mmin +1440 -user www-data -delete
find /tmp/ocpu-www-data/tmp_library -mmin +1440 -user www-data -type d -empty -exec rmdir {} \;
