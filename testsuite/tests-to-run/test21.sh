#!/bin/bash

SERVER1=parallel-server3
SERVER2=parallel-server2

echo '### Test $PARALLEL'
echo | PARALLEL=--number-of-cpus parallel
seq 1 2 | PARALLEL="-S$SERVER1
-Sssh -l parallel $SERVER2
-j1" parallel -kv echo

echo '### Test ~/.parallel/config'
echo "-S$SERVER1
-Sssh -l parallel $SERVER2
-j1" > ~/.parallel/config 
seq 1 2 | parallel -kv echo
rm ~/.parallel/config
