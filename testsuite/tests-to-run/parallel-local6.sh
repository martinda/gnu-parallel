#!/bin/bash

echo '### Test --joblog with exitval and Test --joblog with signal -- timing dependent'
rm -f /tmp/parallel_sleep
parallel --joblog /tmp/parallel_joblog_signal 'sleep {}' ::: 30 2>/dev/null &
parallel --joblog /tmp/parallel_joblog_exitval 'echo foo >/tmp/parallel_sleep; sleep {} && echo sleep was not killed=BAD' ::: 30 2>/dev/null &
while [ ! -e /tmp/parallel_sleep ] ; do
  sleep 1
done
sleep 1
killall -6 sleep
wait
grep -q 134 /tmp/parallel_joblog_exitval && echo exitval=128+6 OK
grep -q '[^0-9]6[^0-9]' /tmp/parallel_joblog_signal && echo signal OK

rm -f /tmp/parallel_joblog_exitval /tmp/parallel_joblog_signal

