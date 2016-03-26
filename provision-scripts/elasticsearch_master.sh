#!/bin/bash
 
ES_VERSION=2.2.1

## http://devopscube.com/how-to-setup-an-elasticsearch-cluster/

echo 'Installing OpenJDK 7'
sudo apt-get install -y openjdk-7-jdk

echo 'Downloading Elasticsearch $ES_VERSION .deb package'
wget –quiet https://download.elasticsearch.org/elasticsearch/release/org/elasticsearch/distribution/deb/elasticsearch/$ES_VERSION/elasticsearch-$ES_VERSION.deb

echo 'Installing ES package'
sudo dpkg -i elasticsearch-$ES_VERSION.deb

echo 'Copying node configuration file'
sudo cp /vagrant/elasticsearch/master-$1.yml /etc/elasticsearch/elasticsearch.yml

echo 'Installing Management Plugins (HQ & HEAD)'
cd /usr/share/elasticsearch/bin
sudo ./plugin install mobz/elasticsearch-head
sudo ./plugin install royrusso/elasticsearch-HQ

echo 'Setting ES to start automatically on reboot'
sudo update-rc.d elasticsearch defaults 95 10

echo 'Starting Elasticsearch service'
sudo service elasticsearch start