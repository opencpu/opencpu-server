echo ""
echo "Hostname guess:"
if [ -f /usr/bin/ec2metadata ]
then
	EC2IP=`timeout 1 ec2metadata --public-ip`
else
	EC2IP=""
fi

if [ "$EC2IP" = "" ]
then
	IPADDR=`ifconfig | perl -ple 'print $_ if /inet addr/ and $_ =~ s/.*inet addr:((?:\d+\.){3}\d+).*/$1/g  ;$_=""' | grep -v ^\s*$ | grep -v 127.0.0.1`
	echo "  http://$IPADDR/R"
else
	echo "  http://$EC2IP/R"
fi

