#!/bin/bash

IPADDR=""
IPADDR=`/usr/lib/opencpu/scripts/getip.sh`

if [ "$IPADDR" = "" ]
then
	echo "  Couldn't detect hostname to find hostname."
else
	echo ""
	echo "  Hostname guess:"
	echo "  https://$IPADDR/ocpu"
	echo ""
fi
