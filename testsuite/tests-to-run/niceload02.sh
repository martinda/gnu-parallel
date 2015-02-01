#!/bin/bash

echo '### Test niceload exit code'
niceload "perl -e 'exit(3)'" ; echo $? eq 3
niceload "perl -e 'exit(0)'" ; echo $? eq 0

# force load > 10
while uptime | grep -v age:.[1-9][0-9].[0-9][0-9] >/dev/null ; do (timeout 5 nice burnP6 2>/dev/null &) done

echo '### Test -p'
perl -e '$|=1;while($t++<3){sleep(1);print "."}' &
# The above will normally take 3.6 sec
# It should be suspended so it at least takes 5 seconds
stdout /usr/bin/time -f %e niceload -l 8 -p $! | perl -ne '$_ >= 5 and print "OK\n"'

echo "### Test --sensor -l negative"
# When the size is bigger, then run
SIZET=/tmp/parallel_sizetest
rm -f $SIZET
tmux new-session -d -n 10 "seq 10000 | pv -qL 1000 > $SIZET"
niceload -t .01 --sensor "stat -c %b $SIZET" -l -10 "stat -c %b $SIZET"
rm $SIZET
