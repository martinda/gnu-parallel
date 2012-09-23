#!/bin/bash

echo '### Test slow arguments generation - https://savannah.gnu.org/bugs/?32834'
seq 1 3 | parallel -j1 "sleep 2; echo {}" | parallel -kj2 echo

echo '### Test --env  - https://savannah.gnu.org/bugs/?37351'
export TWOSPACES='  2  spaces  '
export THREESPACES=" >  My brother's 12\" records  < "
parallel --env TWOSPACES echo 'a"$TWOSPACES"b' ::: 1
parallel --env TWOSPACES --env THREESPACES echo 'a"$TWOSPACES"b' 'a"$THREESPACES"b' ::: 2
parallel --env TWOSPACES,THREESPACES echo 'a"$TWOSPACES"b' 'a"$THREESPACES"b' ::: 2a
parallel -S localhost --env TWOSPACES echo 'a"$TWOSPACES"b' ::: 1
parallel -S localhost --env TWOSPACES --env THREESPACES echo 'a"$TWOSPACES"b' 'a"$THREESPACES"b' ::: 2
parallel -S localhost --env TWOSPACES,THREESPACES echo 'a"$TWOSPACES"b' 'a"$THREESPACES"b' ::: 2a
parallel -S csh@localhost --env TWOSPACES echo 'a"$TWOSPACES"b' ::: 1
parallel -S csh@localhost --env TWOSPACES --env THREESPACES echo 'a"$TWOSPACES"b' 'a"$THREESPACES"b' ::: 2
parallel -S csh@localhost --env TWOSPACES,THREESPACES echo 'a"$TWOSPACES"b' 'a"$THREESPACES"b' ::: 2a

echo '### Test too slow spawning'
killall -9 burnP6 2>/dev/null
seq 1 2 | parallel -j2 -N0 timeout -k 25 26 burnP6 &
sleep 1
seq 1 1000 |
stdout nice nice  parallel -s 100 -uj0 true |
perl -pe '/parallel: Warning: Starting \d+ processes took/ and do {close STDIN; `killall -9 burnP6`; print "OK\n"; exit }'
killall -9 burnP6 2>/dev/null
