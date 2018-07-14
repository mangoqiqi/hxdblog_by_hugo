#!/bin/bash
exec 0< ip_for_run                  

read line                 

echo "$line"

docker run -p 1313:1313 --name=hxdblogserver  hxdbolg:v1.0.0 hugo server --baseUrl=$line --bind=0.0.0.0


