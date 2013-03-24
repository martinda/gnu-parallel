#!/bin/bash

echo '### Test --env all chars except \n,\92,\160 - single and double --onall - no output is good'
# 92 and 160 are special for csh
perl -e 'for(1..9,9,11..91,91,93..159,159,161..255) { printf "%c%c %c%d\0",$_,$_,$_,$_ }' | stdout parallel --nice 10 -j4 -k -I // --arg-sep _ -0 V=// V2=V2=// parallel --retries 5 -k -j1 -S :,1/lo,1/tcsh@lo,1/csh@lo --onall --env V,V2 echo \''"{}$V$V2"'\' ::: {#} | uniq -c | grep -v '   4 '|grep -v xauth |grep -v X11
