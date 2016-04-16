#!/bin/bash
 
docker run \
    -d \
    --name logstash \
    --restart=always \
    -v /vagrant/elasticsearch:/config-dir \
    -v /vagrant/demo:/tmp \
    logstash -f /config-dir/logstash-$1.conf

# writing data to /vagrant/demo on the local machine will be synced to the 
# logstash container's /tmp directory where it will be picked up and sent to ES
echo 'Writing some sample data for Logstash/Kibana demo'
cd /vagrant/demo
touch access_log
echo "Demo message 1" >> access_log
echo "Demo message 2" >> access_log
echo "Something's gone horribly wrong!" >> access_log
