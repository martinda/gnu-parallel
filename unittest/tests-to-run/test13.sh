#!/bin/bash

PAR=parallel

echo '### Test -k'
ulimit -n 50
(echo "sleep 3; echo begin"; seq 1 30 | $PAR -kq echo "sleep 1; echo {}"; echo "echo end") \
| $PAR -k -j0

echo '### Test SIGTERM'
(sleep 5; killall $PAR -TERM) & seq 1 100 | $PAR -k sleep 3';' echo
