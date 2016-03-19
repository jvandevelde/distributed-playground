#!/bin/bash
 
# make sure we have & update any required utils
apt-get update
apt-get install -y unzip
 
# Copy our service Upstart script to the /etc/init folder
# This makes sure consul starts up on system restart and restarts automatically 
cp /vagrant/consul.conf /etc/init/consul.conf
 
# Get and unzip the latest Consul archive  
cd /usr/local/bin
wget https://releases.hashicorp.com/consul/0.6.3/consul_0.6.3_linux_amd64.zip
unzip *.zip
rm *.zip
 
# Make the Consul config and application dirs
mkdir -p /etc/consul.d
mkdir /var/consul
 
# Copy the server configuration. Path to configuration file 
#  passed in via Vagrant shell provisioner args
cp $1 /etc/consul.d/config.json
 
# Start Consul Upstart service
exec /sbin/start consul
#exec consul agent -config-file=/etc/consul.d/config.json