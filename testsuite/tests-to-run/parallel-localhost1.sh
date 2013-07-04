#!/bin/bash

echo '### Test --env all chars except \n,\92,\160 - single and double - no output is good'
# 92 and 160 are special for csh

# This is slow but good for debugging
# perl -e 'for(1..9,9,11..91,91,93..159,159,161..255) { printf "%c%c %c%d\0",$_,$_,$_,$_ }' | stdout parallel --nice 10 -j4 -k -I // --arg-sep _ -0 V=// V2=V2=// parallel --retries 3 -k -j1 -S :,1/lo,1/tcsh@lo,1/csh@lo --env V,V2 echo \''"{}$V$V2"'\' ::: {#} {#} {#} {#} | uniq -c | grep -v '   4 '|grep -v xauth |grep -v X11

# This is fast
perl -e 'for(1..9,9,11..91,91,93..159,159,161..255) { printf "%c",$_ } printf "\0"' |
  stdout parallel -k -I // --arg-sep _ -0 V=// V2=V2=// parallel -k -S 1/:,1/lo,1/tcsh@lo,1/csh@lo --onall --env V,V2 echo \''"{}$V$V2"'\' ::: {#} | uniq -c | grep -v '   4 '|grep -v xauth |grep -v X11

echo '### bug #37262: --slf + --filter-hosts fails'
  parallel --nonall --filter-hosts --sshloginfile <(echo localhost) echo OK
