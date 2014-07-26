#!/bin/bash

echo '### Test -k'
ulimit -n 50
(echo "sleep 3; echo begin"; seq 1 30 | parallel -kq echo "sleep 1; echo {}"; echo "echo end") \
| stdout parallel -k -j0

echo '### Test --keep-order'
(seq 0 2) | parallel --keep-order -j100% -S 1/:,2/parallel@parallel-server2 -q perl -e 'sleep 1;print "job{}\n";exit({})'

echo '### Test --keeporder'
(seq 0 2) | parallel --keeporder -j100% -S 1/:,2/parallel@parallel-server2 -q perl -e 'sleep 1;print "job{}\n";exit({})'

echo '### Test SIGTERM'
parallel -k -j20 sleep 3';' echo ::: {1..99} >/tmp/$$ 2>&1 &
A=$!
sleep 5; kill -TERM $A
wait
sort /tmp/$$

echo '### Test bug: empty line for | sh with -k'
(echo echo a ; echo ; echo echo b) | parallel -k
