#!/bin/bash

SERVER1=parallel-server3
SERVER2=parallel-server2

# -L1 will join lines ending in ' '
cat <<'EOF' | sed -e s/\$SERVER1/$SERVER1/\;s/\$SERVER2/$SERVER2/ | parallel -j0 -k -L1
echo '### Bug in --load'; 
  parallel -k --load 30 sleep 0.1\;echo ::: 1 2 3

echo '### Test --load locally'; 
  echo '# This will force the loadavg > 10'; 
  while uptime | grep -v age:.[1-9][0-9].[0-9][0-9] >/dev/null ; do (timeout 5 nice burnP6 2>/dev/null &) done; 
  stdout /usr/bin/time -f %e parallel --load 10 sleep ::: 1 | perl -ne '$_ > 10 and print "OK\n"'

echo '### Test --load remote'; 
  ssh parallel@$SERVER2 "while uptime | grep -v age:.[1-9][0-9].[0-9][0-9] >/dev/null ; do (timeout 5 nice burnP6 2>/dev/null &) done"; 
  stdout /usr/bin/time -f %e parallel -S parallel@$SERVER2 --load 10 sleep ::: 1 | perl -ne '$_ > 10 and print "OK\n"'
EOF
