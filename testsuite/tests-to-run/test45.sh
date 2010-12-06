#!/bin/bash


SERVER1=parallel-server3
SERVER2=parallel-server2

echo '### Test --load locally'
seq 1 300 | nice timeout -k 1 14  parallel -j0 burnP6
stdout /usr/bin/time -f %e parallel --load 10 sleep ::: 1 | perl -ne '$_ > 10 and print "OK\n"'

echo '### Test --load remote'
seq 1 300 | ssh parallel@$SERVER2 nice timeout -k 1 14 parallel -j0 burnP6
stdout /usr/bin/time -f %e parallel -S parallel@$SERVER2 --load 10 sleep ::: 1 | perl -ne '$_ > 10 and print "OK\n"'
