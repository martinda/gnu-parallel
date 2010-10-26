#!/bin/bash

echo '### Test -k'
ulimit -n 50
(echo "sleep 3; echo begin"; seq 1 30 | parallel -kq echo "sleep 1; echo {}"; echo "echo end") \
| stdout parallel -k -j0

echo '### Test --keep-order'
(seq 0 2) | parallel --keep-order -j100% -S 1/:,2/parallel@server2 -q perl -e 'sleep 1;print "job{}\n";exit({})'

echo '### Test --keeporder'
(seq 0 2) | parallel --keeporder -j100% -S 1/:,2/parallel@server2 -q perl -e 'sleep 1;print "job{}\n";exit({})'

echo '### Test SIGTERM'
(sleep 5; killall parallel -TERM) & seq 1 100 | stdout parallel -k sleep 3';' echo | sort
