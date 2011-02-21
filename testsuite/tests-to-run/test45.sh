#!/bin/bash

SERVER1=parallel-server3
SERVER2=parallel-server2

echo '### Bug in --load'
parallel -k --load 30 sleep 0.1\;echo ::: 1 2 3

echo '### Test --load locally'
# This will force the loadavg > 10
while cat /proc/loadavg | egrep -q '^.\.' ; do
  (nice -n 19 burnP6 &) 2>/dev/null
  sleep .05;
done
killall -9 burnP6 2>/dev/null ;sleep 1;killall -9 burnP6 2>/dev/null
stdout /usr/bin/time -f %e parallel --load 10 sleep ::: 1 | perl -ne '$_ > 10 and print "OK\n"'

echo '### Test --load remote'
# This will force the loadavg > 10
ssh parallel@$SERVER2 "while cat /proc/loadavg | egrep -q '^.\.' ; do
  (nice -n 19 burnP6 &) 2>/dev/null
  sleep .05;
done
killall -9 burnP6 2>/dev/null ;sleep 1;killall -9 burnP6 2>/dev/null
"
stdout /usr/bin/time -f %e parallel -S parallel@$SERVER2 --load 10 sleep ::: 1 | perl -ne '$_ > 10 and print "OK\n"'
