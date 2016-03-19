#!/bin/bash
 
GO_VERSION=1.6

echo 'Updating and installing Ubuntu packages...'
sudo apt-get update
echo 'Install Git'
sudo apt-get -y install git

echo 'Downloading go$GO_VERSION.linux-amd64.tar.gz'
wget –quiet https://storage.googleapis.com/golang/go$GO_VERSION.linux-amd64.tar.gz

echo 'Unpacking go language'
sudo tar -C /usr/local -xzf go$GO_VERSION.linux-amd64.tar.gz

echo 'Setting up environment variables'
#http://stackoverflow.com/questions/7970390/what-should-be-the-values-of-gopath-and-goroot
# $GOROOT is the go installation location, defaults to /usr/local/go, required otherwise
export GOROOT=/usr/local/go
# $GOPATH is your code/workspace for GO programs
export GOPATH=/home/vagrant/go
# $PATH needs to include both with their /bin directories
export PATH=$PATH:$GOPATH/bin:$GOROOT/bin

#Use .profile instead of .bashrc b/c bashrc won't run if not interactive
#http://ubuntuforums.org/showthread.php?t=1413183
echo "export GOROOT=/usr/local/go" >> /home/vagrant/.profile
echo "export GOPATH=/home/vagrant/go" >> /home/vagrant/.profile
echo "export PATH=$PATH:$GOPATH/bin:$GOROOT/bin" >> /home/vagrant/.profile