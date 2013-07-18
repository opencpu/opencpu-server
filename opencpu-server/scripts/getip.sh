#!/bin/bash
IPADDR=""

if [ -f /usr/bin/ec2metadata ]
then
	IPADDR=`timeout 1 ec2metadata --public-hostname`
fi

if [ "$IPADDR" = "" ]
then
	IPADDR=`curl --connect-timeout 1 --max-time 2 http://www.jsonip.com 2> /dev/null | egrep -o "[0-9\.]*"`
fi

if [ "$IPADDR" = "" ]
then
	IPADDR=`curl --connect-timeout 1 --max-time 2 ifconfig.me/host 2> /dev/null`
fi

if [ "$IPADDR" = "" ]
then
	IPADDR=`ifconfig | perl -ple 'print $_ if /inet addr/ and $_ =~ s/.*inet addr:((?:\d+\.){3}\d+).*/$1/g  ;$_=""' | grep -v ^\s*$ | grep -v 127.0.0.1 | head -n 1`
fi

if [ "$IPADDR" = "" ]
then
	IPADDR=`cat /etc/hostname | head -n 1`
fi
echo $IPADDR
