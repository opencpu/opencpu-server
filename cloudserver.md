# Cloud server

These are internal notes from Jeroen on how I set up the public cloud server. 
These are not official instructions! They are specific to my setup. 
Consult the PDF server manual for general instructions

## Setup opencpu-server

New linode server with Ubuntu 16.04. To enable apparmor, change kernel to `GRUB2` which boots the official Ubuntu kernel.

    sudo apt-get update
    sudo apt-get dist-upgrade

    # Add user (interactive)
    sudo adduser jeroen
    sudo visudo
    
    # Change hostname
    sudo echo "dev.opencpu.org" > /etc/hostname

Now reboot. Then login as jeroen 

    sudo apt-get install byobu software-properties-common
    sudo add-apt-repository ppa:opencpu/opencpu-2.0 && sudo apt-get update
    sudo apt-get install opencpu-full
    
    # test it
    curl http://localhost/ocpu/info

## Setup mail server relay

    sudo apt-get install postfix libsasl2-modules
    
Then edit the file `/etc/postfix/sasl_passwd` and add a (replace `PASSWORD` with plaintext password):

    smtp.mailgun.org mail@ocpu.io:PASSWORD
    
Then run:

    sudo postmap /etc/postfix/sasl_passwd
    sudo chmod 0600 /etc/postfix/sasl_passwd /etc/postfix/sasl_passwd.db

Now edit `/etc/postfix/main.cf` and set:

  	# Set by Jeroen
  	relayhost = smtp.mailgun.org
  	
  	# At the end if the fuke
  	smtp_sasl_auth_enable = yes
  	smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd
  	smtp_sasl_security_options = noanonymous

And then run `sudo service postfix restart`

## Copy apps from old server

When upgrading R it may be easier to __reinstall all apps__ using [this script](https://gist.github.com/jeroen/6dd61b356290527b6eea2dde527060d6).

When using the same version of R, we can just copy the installed files:

    sudo -i
    cd /usr/local/lib/opencpu
    rsync -avz -e ssh jeroen@dev.opencpu.org:/usr/local/lib/opencpu/apps .

## Setup nginx cache server

New linode, same steps:

    sudo apt-get update
    sudo apt-get dist-upgrade

    # Add user (interactive)
    sudo adduser jeroen
    sudo visudo
    
    # Change hostname
    sudo echo "dev1.opencpu.org" > /etc/hostname

Now reboot. Then login as jeroen 

    sudo apt-get install byobu software-properties-common
    sudo add-apt-repository ppa:opencpu/opencpu-dev && sudo apt-get update
    sudo apt-get install opencpu-cache
    
Configure the back-end server ip address:

    # Update opencpu server
    sudo vi /etc/nginx/conf.d/opencpu.conf
    
    # Also set rstudio back-end server
    sudo vi /etc/nginx/conf.d/rstudio.conf

Install the SSL private key:

    # Copy the private key
    sudo cp ocpu2017.key /etc/ssl/private/ocpu2017.key
    sudo chmod 600 /etc/ssl/private/ocpu2017.key
    
Enable the ocpu.io site

    sudo ln -s /usr/lib/opencpu/ocpu.io/ocpu-io /etc/nginx/sites-available/ocpu-io
    sudo /usr/lib/opencpu/scripts/nginx_ensite ocpu-io
    sudo /usr/lib/opencpu/scripts/nginx_ensite opencpu-homepage

Now also update the cert in the main site (default uses snakeoil):

    sudo vi /etc/nginx/sites-available/opencpu
    
And restart

    sudo service nginx restart
    
Optionally you can limit connections of the backend from only nginx

    sudo vi /etc/apache2/sites-enabled/opencpu.conf
    
Insert the IP address where it says `require local`, e.g. `require ip 123.123.123.123`. 
Also make sure to close port 80.
    
## Update DNS

Update DNS records for:

  - `ocpu.io`
  - `dev.opencpu.org`
  - `dev1.opencpu.org`

In Linode control panel under 'Remote access' you can set the 'Reverse DNS'.

## Preinstall packages

Get common system requirements from rhub:

    git clone https://github.com/r-hub/sysreqsdb
    cd sysreqsdb/sysreqs
    R -e lapply(list.files(), function(x) {jsonlite::fromJSON(x)[[1]]$platforms$DEB})

Here are some results:

    sudo apt-get install pandoc pandoc-citeproc \
      libapparmor-dev libatk1.0-dev libcairo2-dev libfftw3-dev libhiredis-dev libcurl4-openssl-dev libgdal-dev \
      libgeos-dev libgmp-dev libgsl-dev libpng-dev libproj-dev libprotobuf-dev librsvg2-dev libsecret-1-dev \
      libudunits2-dev libxft-dev libmagick++-dev libxml2-dev libmariadb-client-lgpl-dev libnetcdf-dev unixodbc-dev \
      libgl1-mesa-dev libopenmpi-dev libssl-dev libpango1.0-dev libpq-dev protobuf-compiler libprotoc-dev \
      libsasl2-dev libv8-3.14-dev libsodium-dev libwebp-dev zlib1g-dev libxslt1-dev
      
To preinstall useful packages on cloud server

    sudo add-apt-repository ppa:marutter/c2d4u
    sudo apt-get update
    sudo apt-get install r-cran-tidyverse

To find and install the most popular `r-cran` packages, use [this script](https://git.io/fNp0R) (by revdep) or [this script](https://git.io/vQCP3) (by downloads).
    
Alternatively to find out popular packages use the [CRANlog API](https://github.com/metacran/cranlogs.app#top-downloaded-packages-topperiodcount)

```r
req <- fromJSON('https://cranlogs.r-pkg.org/top/last-month/100')
paste(tolower(paste0("r-cran-", req$downloads$package)), collapse = " ")
```
  
## Making Java Work

Arggh, Java. I think we always jdk:

```
sudo apt-get install openjdk-8-jdk
sudo R CMD javareconf
```

However rApache doesn't read javaconf. The easiest workaround is just

```
sudo ln -s /usr/lib/jvm/default-java/jre/lib/amd64/server/libjvm.so /usr/lib/
```

That should allow for loading the `rJava` package. But there is more. The JVM has a [memory allocation bug](https://stackoverflow.com/questions/19910468/java-and-virtual-memory-ulimit/31431714#31431714) which require you set `rlimit.as` in `/etc/opencpu/server.conf` far boven the required amount of memory.

## Make TensorFlow work

See [here](https://www.tensorflow.org/install/install_linux). I ran this as root:

```
sudo apt-get install python-pip python-dev python-virtualenv 
sudo pip install --upgrade tensorflow h5py
```

