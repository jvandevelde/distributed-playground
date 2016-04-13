#!/bin/bash
 
REDIS_VERSION=3.0.5
PORT=6379
CONFIG_FILE=/etc/redis/6379.conf
LOG_FILE=/var/log/redis_6379.log
DATA_DIR=/var/lib/redis/6379
EXECUTABLE=/usr/local/bin/redis-server

## http://devopscube.com/how-to-setup-an-elasticsearch-cluster/

echo 'Installing tools to build Redis from src'
#sudo apt-get -y install build-essential    #!! we only need make and tcl
sudo apt-get -y install cmake
sudo apt-get -y install tcl8.5

echo 'Downloading and unpacking Redis $REDIS_VERSION source'
wget -c http://download.redis.io/releases/redis-$REDIS_VERSION.tar.gz
tar xzf redis-$REDIS_VERSION.tar.gz 
mv redis-$REDIS_VERSION redis

echo 'Building and creating Redis distribution'
cd redis
make
sudo make install

echo 'Installing Redis as a service using defaults'
# The install_server.sh in the Redis build output is an interactive script
# We're going to use the method documented at https://realguess.net/2014/07/19/non-interactive-redis-install/ 
# to execute the script unattended
## sudo ./install_server.sh
echo -e \
  "${PORT}\n${CONFIG_FILE}\n${LOG_FILE}\n${DATA_DIR}\n${EXECUTABLE}\n" | \
  sudo utils/install_server.sh

echo 'Setting service to auto-start and starting...'
sudo update-rc.d redis_6379 defaults
sudo service redis_6379 startcd 