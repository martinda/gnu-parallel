#!/bin/bash

# Simple jobs taking 100s that can be run in parallel
cat <<'EOF' | sed -e 's/;$/; /;s/$SERVER1/'$SERVER1'/;s/$SERVER2/'$SERVER2'/' | stdout parallel -k -L1
echo "### Test Force outside the file handle limit, 2009-02-17 Gave fork error"; 
  (echo echo Start; seq 1 20000 | perl -pe 's/^/true /'; echo echo end) | parallel -uj 0

echo '### Test race condition on 8 CPU (my laptop)'; 
  seq 1 5000000 > /tmp/parallel_test; 
  seq 1 10 | parallel -k "cat /tmp/parallel_test | parallel --pipe --recend '' -k gzip >/dev/null; echo {}"

echo '### Test exit val - true'; 
  echo true | parallel; 
  echo $?

echo '### Test exit val - false'; 
  echo false | parallel; 
  echo $?

echo '### Test --halt-on-error 0'; 
  (echo "sleep 1;true"; echo "sleep 2;false";echo "sleep 3;true") | parallel -j10 --halt-on-error 0; 
  echo $?; 
  (echo "sleep 1;true"; echo "sleep 2;false";echo "sleep 3;true";echo "sleep 4; non_exist") | parallel -j10 --halt 0; 
  echo $?

echo '### Test --halt-on-error 1'; 
  (echo "sleep 1;true"; echo "sleep 2;false";echo "sleep 3;true") | parallel -j10 --halt-on-error 1; 
  echo $?; 
  (echo "sleep 1;true"; echo "sleep 2;false";echo "sleep 3;true";echo "sleep 4; non_exist") | parallel -j10 --halt 1; 
  echo $?

echo '### Test --halt-on-error 2'; 
  (echo "sleep 1;true"; echo "sleep 2;false";echo "sleep 3;true") | parallel -j10 --halt-on-error 2; 
  echo $?; 
  (echo "sleep 1;true"; echo "sleep 2;false";echo "sleep 3;true";echo "sleep 4; non_exist") | parallel -j10 --halt 2; 
  echo $?

echo '### Test last dying print --halt-on-error'; 
  (seq 0 8;echo 0; echo 9) | parallel -j10 -kq --halt 1 perl -e 'sleep $ARGV[0];print STDERR @ARGV,"\n"; exit shift'; 
  echo $?; 
  (seq 0 8;echo 0; echo 9) | parallel -j10 -kq --halt 2 perl -e 'sleep $ARGV[0];print STDERR @ARGV,"\n"; exit shift'; 
  echo $?

echo '### Test slow arguments generation - https://savannah.gnu.org/bugs/?32834'; 
  seq 1 3 | parallel -j1 "sleep 2; echo {}" | parallel -kj2 echo

EOF

