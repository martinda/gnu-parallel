#!/bin/bash

echo '### Test --joblog with exitval'
parallel --joblog /tmp/parallel_test_joblog 'sleep {} && echo foo' ::: 100 2>/dev/null &
sleep 1
killall -6 sleep
grep -q 134 /tmp/parallel_test_joblog && echo OK

echo '### Test --joblog with signal'
parallel --joblog /tmp/parallel_test_joblog 'sleep {}' ::: 100 2>/dev/null &
sleep 1
killall -6 sleep
grep -q '[^0-9]6[^0-9]' /tmp/parallel_test_joblog && echo OK

rm /tmp/parallel_test_joblog
