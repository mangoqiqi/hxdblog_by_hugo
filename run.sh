#!/bin/bash
exec 0< ip_for_run                  

read line                 

echo "$line"
docker run -d -p 1313:1313 --name=hugoblogserver  hugoblog:v1.0.0  server --baseUrl=$line --bind=0.0.0.0