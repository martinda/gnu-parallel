#!/bin/bash

rsync -Ha --delete input-files/segfault/ tmp/
cd tmp

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

echo '### Test --timeout'; 
  parallel -j0 -k --timeout 1 echo {}\; sleep {}\; echo {} ::: 1.1 3.3 4.4 5.5

echo '### Test retired'; 
  stdout parallel -B; 
  stdout parallel -g; 
  stdout parallel -H; 
  stdout parallel -T; 
  stdout parallel -U; 
  stdout parallel -W; 
  stdout parallel -Y;

echo '### Test --joblog followed by --resume --joblog'; 
  rm -f /tmp/joblog; 
  timeout -k 1 1 parallel -j2 --joblog /tmp/joblog sleep {} ::: 1.1 2.2 3.3 4.4 2>/dev/null; 
  parallel -j2 --resume --joblog /tmp/joblog sleep {} ::: 1.1 2.2 3.3 4.4; 
  cat /tmp/joblog | wc; 
  rm -f /tmp/joblog;

echo '### Test --resume --joblog followed by --resume --joblog'; 
  rm -f /tmp/joblog2; 
  timeout -k 1 1 parallel -j2 --resume --joblog /tmp/joblog2 sleep {} ::: 1.1 2.2 3.3 4.4 2>/dev/null; 
  parallel -j2 --resume --joblog /tmp/joblog2 sleep {} ::: 1.1 2.2 3.3 4.4; 
  cat /tmp/joblog2 | wc; 
  rm -f /tmp/joblog2;

echo '### Test --header'; 
  printf "a\tb\n1.2\t3/4.5" | parallel --header "\n" echo {b} {a} {b.} {b/} {b//} {b/.}; 

echo '### 64-bit wierdness - this did not complete on a 64-bit machine'; 
  seq 1 2 | parallel -j1 'seq 1 1 | parallel true'

echo "### BUG-fix: bash -c 'parallel -a <(seq 1 3) echo'"; 
  stdout bash -c 'parallel -k -a <(seq 1 3)  echo'

echo "### BUG: The length for -X is not close to max (131072)"; 
  seq 1 60000 | parallel -X echo {.} aa {}{.} {}{}d{} {}dd{}d{.} |head -n 1 |wc; 
  seq 1 60000 | parallel -X echo a{}b{}c |head -n 1 |wc; 
  seq 1 60000 | parallel -X echo |head -n 1 |wc; 
  seq 1 60000 | parallel -X echo a{}b{}c {} |head -n 1 |wc; 
  seq 1 60000 | parallel -X echo {}aa{} |head -n 1 |wc; 
  seq 1 60000 | parallel -X echo {} aa {} |head -n 1 |wc;

echo "### bug #35268: shell_quote doesn't treats [] brackets correctly"; 
  touch /tmp/foo1; 
  stdout parallel echo ::: '/tmp/foo[123]'

echo '### Test make .deb package'; 
  cd ~/privat/parallel/packager/debian; 
  stdout make | grep 'To install the GNU Parallel Debian package, run:'

echo '### Test of segfaulting issue'; 
  echo 'This gave /home/tange/bin/stdout: line 3: 20374 Segmentation fault      "$@" 2>&1'; 
  echo 'before adding wait() before exit'; 
  seq 1 300 | stdout parallel ./trysegfault

echo '### Test basic --arg-sep'; 
  parallel -k echo ::: a b

echo '### Run commands using --arg-sep'; 
  parallel -kv ::: 'echo a' 'echo b'

echo '### Change --arg-sep'; 
  parallel --arg-sep ::: -kv ::: 'echo a' 'echo b'; 
  parallel --arg-sep .--- -kv .--- 'echo a' 'echo b'; 
  parallel --argsep ::: -kv ::: 'echo a' 'echo b'; 
  parallel --argsep .--- -kv .--- 'echo a' 'echo b'

echo '### Test stdin goes to first command only'
echo via cat |parallel --arg-sep .--- -kv .--- 'cat' 'echo b'
echo via cat |parallel -kv ::: 'cat' 'echo b'

echo '### Bug made 4 5 go before 1 2 3'; 
  parallel -k ::: "sleep 1; echo 1" "echo 2" "echo 3" "echo 4" "echo 5"

echo '### Bug made 3 go before 1 2'; 
  parallel -kj 1 ::: "sleep 1; echo 1" "echo 2" "echo 3"

echo '### Bug did not quote'; 
  echo '>' | parallel -v echo; 
  parallel -v echo ::: '>'; 
  (echo '>'; echo  2) | parallel -j1 -vX echo; 
  parallel -X -j1 echo ::: '>' 2

echo '### Must not quote'; 
  echo 'echo | wc -l' | parallel -v; 
  parallel -v ::: 'echo | wc -l'; 
  echo 'echo a b c | wc -w' | parallel -v; 
  parallel -kv ::: 'echo a b c | wc -w' 'echo a b | wc -w'

EOF
