#!/bin/bash

killall ruby2.4
sleep 5
nohup smashing start -p 12922 &
