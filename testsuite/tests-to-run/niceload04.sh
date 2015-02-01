#!/bin/bash

cp /bin/sleep /tmp/mysleep
killall -9 mysleep 2>/dev/null

# force load > 10
while uptime | grep -v age:.[1-9][0-9].[0-9][0-9] >/dev/null ; do (timeout 5 nice burnP6 2>/dev/null &) done

sleep 2 &
export PID1=$!
sleep 2 &
export PID2=$!
sleep 2 &
export PID3=$!
echo '### multiple -p'
  stdout /usr/bin/time -f %e niceload -l 9 -H -p $PID1 -p $PID2 -p $PID3 | perl -ne '$_ > 5 and print "Multiple -p OK\n"' &

/tmp/mysleep 2 &
/tmp/mysleep 2 &
/tmp/mysleep 2 &
echo '### --prg'
  stdout /usr/bin/time -f %e niceload -l 8 -H --prg mysleep | perl -ne '$_ > 5 and print "--prg OK\n"'
rm /tmp/mysleep
