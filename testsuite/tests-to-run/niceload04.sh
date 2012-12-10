#!/bin/bash

# force load > 10
while uptime | grep -v age:.[1-9][0-9].[0-9][0-9] >/dev/null ; do (timeout 5 nice burnP6 2>/dev/null &) done

sleep 1 &
PID1=$!
sleep 1 &
PID2=$!
sleep 1 &
PID3=$!
stdout /usr/bin/time -f %e niceload -l 8 -H -p $PID1 -p $PID2 -p $PID3 | perl -ne '$_ >= 5 and print "OK\n"'
