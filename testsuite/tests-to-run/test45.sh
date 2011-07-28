#!/bin/bash

SERVER1=parallel-server3
SERVER2=parallel-server2

# -L1 will join lines ending in ' '
cat <<'EOF' | sed -e s/\$SERVER1/$SERVER1/\;s/\$SERVER2/$SERVER2/ | parallel -j0 -k -L1
echo '### Test --load locally'; 
  echo '# This will force the loadavg > 10'; 
  while uptime | grep -v age:.[1-9][0-9].[0-9][0-9] >/dev/null ; do (timeout 5 nice burnP6 2>/dev/null &) done; 
  stdout /usr/bin/time -f %e parallel --load 10 sleep ::: 1 | perl -ne '$_ > 10 and print "OK\n"'

echo '### Test --load remote'; 
  ssh parallel@$SERVER2 "while uptime | grep -v age:.[1-9][0-9].[0-9][0-9] >/dev/null ; do (timeout 5 nice burnP6 2>/dev/null &) done"; 
  stdout /usr/bin/time -f %e parallel -S parallel@$SERVER2 --load 10 sleep ::: 1 | perl -ne '$_ > 10 and print "OK\n"'

echo '### Test --load read from a file - more than 3s'; 
  echo '# This will force the loadavg > 10'; 
  while uptime | grep -v age:.[1-9][0-9].[0-9][0-9] >/dev/null ; do (timeout 5 nice burnP6 2>/dev/null &) done; 
  ( echo 8 > /tmp/parallel_load_file; sleep 3; echo 100 > /tmp/parallel_load_file ) & 
  stdout /usr/bin/time -f %e parallel --load /tmp/parallel_load_file sleep ::: 1 | perl -ne '$_ > 3 and print "OK\n"'

echo '### Test --load read from a file - less than 10s'; 
  echo '# This will force the loadavg > 10'; 
  while uptime | grep -v age:.[1-9][0-9].[0-9][0-9] >/dev/null ; do (timeout 5 nice burnP6 2>/dev/null &) done; 
  ( echo 8 > /tmp/parallel_load_file2; sleep 3; echo 100 > /tmp/parallel_load_file2 ) & 
  stdout /usr/bin/time -f %e parallel --load /tmp/parallel_load_file2 sleep ::: 1 | perl -ne '$_ < 10 and print "OK\n"'

echo '### Bug in --load'; 
  parallel -k --load 30 sleep 0.1\;echo ::: 1 2 3

EOF
