#!/bin/bash
 
docker run -d --name demosvc.1.$1.inst1 \
--restart=always                        \
-p 5001:5000                            \
-e SERVICE_NAME=demosvc.1               \
-e SERVICE_5000_CHECK_HTTP=/            \
-e SERVICE_5000_CHECK_INTERVAL=5s       \
-e SERVICE_TAGS=urlprefix-/             \
-e DOCKER_ENV_VAR1=demosvc.1.$1.inst1   \
jvandevelde/aspnetcoredemo

docker run -d --name demosvc.1.$1.inst2 \
--restart=always                        \
-p 5002:5000                            \
-e SERVICE_NAME=demosvc.1               \
-e SERVICE_5000_CHECK_HTTP=/            \
-e SERVICE_5000_CHECK_INTERVAL=5s       \
-e SERVICE_TAGS=urlprefix-/             \
-e DOCKER_ENV_VAR1=demosvc.1.$1.inst2   \
jvandevelde/aspnetcoredemo

docker run -d --name demosvc.1.$1.inst3 \
--restart=always                        \
-p 5003:5000                            \
-e SERVICE_NAME=demosvc.1               \
-e SERVICE_5000_CHECK_HTTP=/            \
-e SERVICE_5000_CHECK_INTERVAL=5s       \
-e SERVICE_TAGS=urlprefix-/             \
-e DOCKER_ENV_VAR1=demosvc.1.$1.inst3   \
jvandevelde/aspnetcoredemo