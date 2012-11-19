#!/bin/bash

echo '### Test --joblog with exitval and Test --joblog with signal'
parallel --joblog /tmp/parallel_joblog_exitval 'sleep {} && echo sleep was not killed=BAD' ::: 100 2>/dev/null &
parallel --joblog /tmp/parallel_joblog_signal 'sleep {}' ::: 100 2>/dev/null &
sleep 1
killall -6 sleep
sleep 0.1
grep -q 134 /tmp/parallel_joblog_exitval && echo exitval OK
grep -q '[^0-9]6[^0-9]' /tmp/parallel_joblog_signal && echo signal OK

rm /tmp/parallel_joblog_exitval /tmp/parallel_joblog_signal

