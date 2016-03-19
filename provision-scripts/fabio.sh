#!/bin/bash

# TODO: Figure out why these env vars are not accessible even though
#       previously set up in provision_go.sh
export GOROOT=/usr/local/go
export GOPATH=/home/vagrant/go
export PATH=$PATH:$GOPATH/bin:$GOROOT/bin

# Install fabio http router from source. Assumes GO is already installed
echo "Installing Fabio HTTP router"
GO15VENDOREXPERIMENT=1 go get github.com/eBay/fabio

# create fabio configuration file
#touch fabio.properties
sudo echo "registry.consul.addr = 172.28.128.10:8500" >> $GOPATH/bin/fabio.properties
# to make sure a script is executing in the context of the directory it's located in
# http://askubuntu.com/questions/74780/how-to-execute-script-in-different-directory
sudo echo "$GOPATH/bin/fabio -cfg $GOPATH/bin/fabio.properties" >> $GOPATH/bin/fabio.sh
sudo chmod +x $GOPATH/bin/fabio.sh


echo "Installing & starting Fabio service"
# Copy the upstart script to the /etc/init folder
cp /vagrant/fabio.conf /etc/init/fabio.conf

# the following can be used to debug upstart scripts
#sudo initctl log-priority debug
#https://www.digitalocean.com/community/tutorials/the-upstart-event-system-what-it-is-and-how-to-use-it

# start the fabio process via upstart
exec /sbin/start fabio
#cd $GOPATH/bin
#./fabio -cfg fabio.properties