#!/bin/bash
 
docker run --name consul -h $1  \
--restart=always      \
-p $1:8300:8300       \
-p $1:8301:8301       \
-p $1:8301:8301/udp   \
-p $1:8302:8302       \
-p $1:8302:8302/udp   \
-p $1:8400:8400       \
-p $1:8500:8500       \
-p 172.17.0.1:53:53/udp         \
-d -v /mnt:/data progrium/consul -server -advertise $1 -join 172.28.128.10

docker run -h docker-1  \
--restart=always        \
-v "/var/run/docker.sock:/tmp/docker.sock"  \
--name registrator      \
-d gliderlabs/registrator:latest --ip $1 consul://$1:8500