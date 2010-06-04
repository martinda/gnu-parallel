#!/bin/bash

PAR=parallel
SERVER1=parallel-server1
SERVER2=parallel-server2

echo '### Test $PARALLEL'
echo | PARALLEL=--number-of-cpus $PAR 
seq 1 2 | PARALLEL="-S$SERVER1
-Sssh -l parallel $SERVER2
-j1" $PAR -kv echo

echo '### Test ~/.parallelrc'
echo "-S$SERVER1
-Sssh -l parallel $SERVER2
-j1" > ~/.parallelrc 
seq 1 2 | $PAR -kv echo
rm ~/.parallelrc
