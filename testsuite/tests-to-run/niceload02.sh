#!/bin/bash

echo '### Test niceload exit code'
niceload "perl -e 'exit(3)'" ; echo $? eq 3
niceload "perl -e 'exit(0)'" ; echo $? eq 0

# force load > 10
while uptime | grep -v age:.[1-9][0-9].[0-9][0-9] >/dev/null ; do (timeout 5 nice burnP6 2>/dev/null &) done

echo '### Test -p'
perl -e '$|=1;while($t++<3){sleep(1);print "."}' &
# The above should be suspended for at least 4 seconds
stdout /usr/bin/time -f %e niceload -D -l 9 -p $! | perl -ne '$_ > 6 and print "OK\n"'
