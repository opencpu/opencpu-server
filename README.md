OpenCPU Cloud Server
--------------------

Install on Ubuntu (12.04 and up):

    sudo add-apt-repository ppa:opencpu/opencpu-0.8
    sudo apt-get update
    sudo apt-get install opencpu
    
To stop/start/restart server

    sudo service opencpu restart
    
To stop/start/restart caching server

    sudo service opencpu-cache stop
    
OpenCPU server will run at http://localhost/ocpu by default.