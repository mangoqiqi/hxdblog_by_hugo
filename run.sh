#!/bin/bash
exec 0< ip_for_run                  

read line                 

echo "$line"

docker run -p 1313:1313 --name=hxdblogserver -e HUGO_BASE_URL="$line" hxdbolg:v1.0.0 


