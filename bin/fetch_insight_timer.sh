#!/bin/bash

curl -s -c cookie.txt -d "user_session[email]=$1" -d "user_session[password]=$2" https://insighttimer.com/user_session >/dev/null
curl -b cookie.txt https://insighttimer.com/sessions/export
