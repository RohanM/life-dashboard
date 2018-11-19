#!/bin/bash

COOKIE_FILE=$HOME/tmp/map_my_run.cookie
mkdir -p $HOME/tmp

curl 'https://www.mapmyrun.com/auth/login' -s -c $COOKIE_FILE -H 'Content-Type: application/json' -H 'Accept: application/json, text/plain, */*' --data-binary "{\"username\":\"$1\",\"password\":\"$2\"}" > /dev/null
curl 'https://www.mapmyrun.com/workout/export/csv' -b $COOKIE_FILE -H 'Accept-Encoding: gzip, deflate' -H 'Accept-Language: en-GB,en;q=0.8,en-US;q=0.6'
