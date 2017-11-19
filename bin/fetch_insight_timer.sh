#!/bin/bash

COOKIE_FILE=$HOME/tmp/insight_timer.cookie
mkdir -p $HOME/tmp

curl -s -c $COOKIE_FILE -d "user_session[email]=$1" -d "user_session[password]=$2" https://insighttimer.com/user_session >/dev/null
curl -b $COOKIE_FILE https://insighttimer.com/sessions/export
