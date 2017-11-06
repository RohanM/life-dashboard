#!/bin/bash

curl 'https://www.mapmyrun.com/auth/login' -s -c cookie-mmr.txt -H 'Content-Type: application/json' -H 'Accept: application/json, text/plain, */*' --data-binary '{"username":"$1","password":"$2"}' >/dev/null
curl 'http://www.mapmyrun.com/workout/export/csv' -b cookie-mmr.txt -H 'Accept-Encoding: gzip, deflate' -H 'Accept-Language: en-GB,en;q=0.8,en-US;q=0.6'
