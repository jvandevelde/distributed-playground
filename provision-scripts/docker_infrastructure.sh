#!/bin/bash
 
docker run -d --name logstash --restart=always -v /vagrant/elasticsearch:/config-dir logstash -f /config-dir/logstash.conf

echo 'Writing some sample data for Logstash/Kibana demo'
cd /tmp
touch access_log
echo "Demo message 1" >> access_log
echo "Demo message 2" >> access_log
echo "Something's gone horribly wrong!" >> access_log
