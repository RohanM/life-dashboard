#!/bin/bash

COOKIE_FILE=$HOME/tmp/insight_timer.cookie
mkdir -p $HOME/tmp

curl -s -c $COOKIE_FILE -d "user_session[email]=$1" -d "user_session[password]=$2" https://profile.insighttimer.com/profile_signin/request >/dev/null
curl -b $COOKIE_FILE https://profile.insighttimer.com/sessions/export
