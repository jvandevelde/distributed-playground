#!/bin/bash
 
docker run -d --name logstash --restart=always -v /vagrant/elasticsearch:/config-dir logstash -f /config-dir/logstash.conf