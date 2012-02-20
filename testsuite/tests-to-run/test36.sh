#!/bin/bash

SERVER1=parallel-server3
SERVER2=parallel-server2

echo '### Test $PARALLEL_SEQ - local'
seq 1 20 | parallel -kN2 echo arg1:{1} seq:'$'PARALLEL_SEQ arg2:{2}

echo '### Test $PARALLEL_SEQ - remote'
seq 1 20 | parallel -kN2 -S parallel@$SERVER1,parallel@$SERVER2 echo arg1:{1} seq:'$'PARALLEL_SEQ arg2:{2}

echo '### Test $PARALLEL_PID - local'
seq 1 20 | parallel -kN2 echo arg1:{1} pid:'$'PARALLEL_PID arg2:{2} | perl -pe 's/\d{3,}/0/g'

echo '### Test $PARALLEL_PID - remote'
seq 1 20 | parallel -kN2 -S parallel@$SERVER1,parallel@$SERVER2 echo arg1:{1} pid:'$'PARALLEL_PID arg2:{2} | perl -pe 's/\d{3,}/0/g'
