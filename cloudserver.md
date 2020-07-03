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
    sudo add-apt-repository ppa:opencpu/opencpu-2.2 && sudo apt-get update
    sudo apt-get install opencpu-server
    
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
    sudo cp ocpu2017.key /etc/letsencrypt/live/ocpu.io/privkey.pem
    sudo chmod 600 /etc/letsencrypt/live/ocpu.io/privkey.pem
    
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

## Enable RSPM

Edit `/etc/opencpu/Rprofile` and add:

    options(repos = c(CRAN = "https://packagemanager.rstudio.com/all/__linux__/focal/latest"))
    options(HTTPUserAgent = sprintf("R/%s R (%s)", getRversion(), paste(getRversion(), R.version$platform, R.version$arch, R.version$os)))

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
sudo apt-get install python3-pip python3-dev python3-virtualenv 
sudo pip3 install --upgrade tensorflow h5py
```

