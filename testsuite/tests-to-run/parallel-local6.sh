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

echo '### Test --env all chars except \n,\92,\160 - single and double - no output is good'
# 92 and 160 are special for csh
perl -e 'for(1..9,9,11..91,91,93..159,159,161..255) { printf "%c%c %c%d\0",$_,$_,$_,$_ }' | stdout parallel --nice 10 -j4 -k -I // --arg-sep _ -0 V=// V2=V2=// parallel -k -j1 -S :,1/lo,1/tcsh@lo,1/csh@lo --env V,V2 echo \''"{}$V$V2"'\' ::: {#} {#} {#} {#} | uniq -c | grep -v '   4 '|grep -v xauth |grep -v X11

echo '### Test --env all chars except \n,\92,\160 - single and double --onall - no output is good'
# 92 and 160 are special for csh
perl -e 'for(1..9,9,11..91,91,93..159,159,161..255) { printf "%c%c %c%d\0",$_,$_,$_,$_ }' | stdout parallel --nice 10 -j4 -k -I // --arg-sep _ -0 V=// V2=V2=// parallel -k -j1 -S :,1/lo,1/tcsh@lo,1/csh@lo --onall --env V,V2 echo \''"{}$V$V2"'\' ::: {#} | uniq -c | grep -v '   4 '|grep -v xauth |grep -v X11
