#!/bin/sh
tmp="/tmp"

# Test if we are running systemd
if [ -d "/run/systemd/system" ]; then
PID=$(systemctl show --property MainPID --value apache2)
if [ "$PID" ] && [ $PID -ne 0 ] && [ -d "/proc/$PID/root/tmp" ]; then
tmp="/proc/$PID/root/tmp"
fi
fi
ocputemp="$tmp/ocpu-temp"
ocpustore="$tmp/ocpu-store"

#This script removes tempfiles that are over an hour old
if [ -d "$ocputemp" ]; then
    find "$ocputemp" -mindepth 1 -mmin +60 -user www-data -delete || true
    find "$ocputemp" -mindepth 1 -mmin +60 -user www-data -type d -empty -exec rmdir {} \; || true
fi

#This removes entries from the "temporary library" over a day old.
if [ -d "$ocpustore" ]; then
    find "$ocpustore" -mindepth 1 -mmin +1440 -user www-data -delete || true
    find "$ocpustore" -mindepth 1 -mmin +1440 -user www-data -type d -empty -exec rmdir {} \; || true
fi
