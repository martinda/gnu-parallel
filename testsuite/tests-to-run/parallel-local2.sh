#!/bin/bash

echo '### Test slow arguments generation - https://savannah.gnu.org/bugs/?32834'
seq 1 3 | parallel -j1 "sleep 2; echo {}" | parallel -kj2 echo

echo '### Test too slow spawning'
killall -9 burnP6 2>/dev/null
seq `parallel --number-of-cores` | parallel -j100% -N0 timeout -k 25 26 burnP6 &
sleep 1
seq 1 1000 |
stdout nice nice  parallel -s 100 -uj0 true |
perl -pe '/parallel: Warning: Starting \d+ processes took/ and do {close STDIN; `killall -9 burnP6`; print "OK\n"; exit }'
killall -9 burnP6 2>/dev/null

echo '### Test --env  - https://savannah.gnu.org/bugs/?37351'
export TWOSPACES='  2  spaces  '
export THREESPACES=" >  My brother's 12\" records  < "
stdout parallel --env TWOSPACES echo 'a"$TWOSPACES"b' ::: 1
stdout parallel --env TWOSPACES --env THREESPACES echo 'a"$TWOSPACES"b' 'a"$THREESPACES"b' ::: 2
stdout parallel --env TWOSPACES,THREESPACES echo 'a"$TWOSPACES"b' 'a"$THREESPACES"b' ::: 2a
stdout parallel -S localhost --env TWOSPACES echo 'a"$TWOSPACES"b' ::: 1
stdout parallel -S localhost --env TWOSPACES --env THREESPACES echo 'a"$TWOSPACES"b' 'a"$THREESPACES"b' ::: 2
stdout parallel -S localhost --env TWOSPACES,THREESPACES echo 'a"$TWOSPACES"b' 'a"$THREESPACES"b' ::: 2a

echo '### Test --env all chars except \n - single and double - no output is good'
perl -e 'for(1..9,9,11..255) { printf "%c%c %c%d\0",$_,$_,$_,$_ }' | stdout parallel --nice 19 -j4 -k -I // --arg-sep _ -0 V=// V2=V2=// parallel -k -j1 -S :,1/lo,1/tcsh@lo,1/csh@lo --env V,V2 echo \''"{}$V$V2"'\' ::: {#} {#} {#} {#} | uniq -c | grep -v '   4 '|grep -v xauth |grep -v X11

echo '### Test --env all chars except \n - single and double --onall - no output is good'
perl -e 'for(1..9,9,11..255) { printf "%c%c %c%d\0",$_,$_,$_,$_ }' | stdout parallel --nice 19 -j4 -k -I // --arg-sep _ -0 V=// V2=V2=// parallel -k -j1 -S :,1/lo,1/tcsh@lo,1/csh@lo --onall --env V,V2 echo \''"{}$V$V2"'\' ::: {#} | uniq -c | grep -v '   4 '|grep -v xauth |grep -v X11

