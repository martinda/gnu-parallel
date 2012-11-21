#!/bin/bash

echo '### Test slow arguments generation - https://savannah.gnu.org/bugs/?32834'
seq 1 3 | parallel -j1 "sleep 2; echo {}" | parallel -kj2 echo

echo '### Test too slow spawning'
killall -9 burnP6 2>/dev/null
seq `parallel --number-of-cores` | parallel -j200% -N0 timeout -k 25 26 burnP6 &
sleep 1
seq 1 1000 |
stdout nice nice  parallel -s 100 -uj0 true |
perl -pe '/parallel: Warning: Starting \d+ processes took/ and do {close STDIN; `killall -9 burnP6`; print "OK\n"; exit }'
killall -9 burnP6 2>/dev/null
