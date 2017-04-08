Setup OpenCPU demo server
-------------------------

Install opencpu on the CPU server:

```sh
sudo apt-get install opencpu-server opencpu-tex rstudio-server pandoc
```

Configure `Require ip` in `/etc/apache2/sites-enabled/opencpu.conf`:

```apacheconf
Listen 8004
<VirtualHost *:8004>

	DocumentRoot /var/www/html

	<Location />
		# This assumes Apache 2.4
		Require ip 131.179.144.170
	</Location>

	LogLevel info
	ErrorLog /var/log/opencpu/apache_error.log
	CustomLog /var/log/opencpu/apache_access.log combined

</VirtualHost>
```

Create or modify `/etc/opencpu/secret.conf` if needed and restart:

```sh
sudo service opencpu restart
```

## Nginx server

Install cache server:

```sh
sudo apt-get install opencpu-cache
```

Install private SSL key

```sh
sudo cp ocpu2017.key /etc/ssl/private/ocpu2017.key 
sudo chgrp ssl-cert /etc/ssl/private/ocpu2017.key
sudo chmod 640 /etc/ssl/private/ocpu2017.key
```

Edit config files:


 - Replace cert+key from snakeoil to ocpu2017 in /etc/nginx/sites-enabled/opencpu
 - Modify nginx back-end server ip address in /etc/nginx/conf.d/opencpu.conf
 - Modify rstudio back-end server in /etc/nginx/opencpu.d/rstudio.conf

Enable ocpu.io

```sh
sudo ln -s /usr/lib/opencpu/ocpu.io/ocpu-io /etc/nginx/sites-available/
sudo /usr/lib/opencpu/scripts/nginx_ensite ocpu-io
sudo service opencpu-cache restart
```
