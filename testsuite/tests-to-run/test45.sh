#!/bin/bash

SERVER1=parallel-server3
SERVER2=parallel-server1

# -L1 will join lines ending in ' '
cat <<'EOF' | sed -e s/\$SERVER1/$SERVER1/\;s/\$SERVER2/$SERVER2/ | parallel -j0 -k -L1
echo "### BUG: The length for -X is not close to max (131072)"; 
  seq 1 60000 | nice parallel -X echo {.} aa {}{.} {}{}d{} {}dd{}d{.} |head -n 1 |wc
  seq 1 60000 | nice parallel -X echo a{}b{}c |head -n 1 |wc
  seq 1 60000 | nice parallel -X echo |head -n 1 |wc
  seq 1 60000 | nice parallel -X echo a{}b{}c {} |head -n 1 |wc
  seq 1 60000 | nice parallel -X echo {}aa{} |head -n 1 |wc
  seq 1 60000 | nice parallel -X echo {} aa {} |head -n 1 |wc

echo '### bug #32191: Deep recursion on subroutine main::get_job_with_sshlogin'
  seq 1 150 | stdout parallel -j9 --retries 2 -S localhost,: "/bin/non-existant 2>/dev/null"

echo '### Test --load locally - should take >10s'
  echo '# This will run 10 processes in parallel for 10s'; 
  seq 10 | parallel --nice 19 --timeout 10 -j0 -N0 "gzip < /dev/zero > /dev/null" &
  stdout /usr/bin/time -f %e parallel --load 10 sleep ::: 1 | perl -ne '$_ > 10 and print "OK\n"'

echo '### Test --load remote'
  ssh parallel@$SERVER2 'seq 10 | parallel --timeout 10 -j0 -N0 "gzip < /dev/zero > /dev/null"' &
  stdout /usr/bin/time -f %e parallel -S parallel@$SERVER2 --load 10 sleep ::: 1 | perl -ne '$_ > 10 and print "OK\n"'

echo '### Test --load read from a file - more than 3s'
  echo '# This will run 10 processes in parallel for 10s'; 
  seq 10 | parallel --nice 19 --timeout 10 -j0 -N0 "gzip < /dev/zero > /dev/null" &
  ( echo 8 > /tmp/parallel_load_file; sleep 4; echo 1000 > /tmp/parallel_load_file ) & 
  sleep 1;stdout /usr/bin/time -f %e parallel --load /tmp/parallel_load_file sleep ::: 1 | perl -ne '$_ > 3 and print "OK\n"'

echo '### Test --load read from a file - less than 10s'; 
  echo '# This will run 10 processes in parallel for 10s'; 
  seq 10 | parallel --nice 19 --timeout 10 -j0 -N0 "gzip < /dev/zero > /dev/null" &
  ( echo 8 > /tmp/parallel_load_file2; sleep 4; echo 1000 > /tmp/parallel_load_file2 ) & 
  stdout /usr/bin/time -f %e parallel --load /tmp/parallel_load_file2 sleep ::: 1 | perl -ne '$_ < 10 and print "OK\n"'

EOF
