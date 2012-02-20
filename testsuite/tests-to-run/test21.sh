#!/bin/bash

SERVER1=parallel-server3
SERVER2=parallel-server2

echo '### Test $PARALLEL - single line'
echo | PARALLEL=--number-of-cpus parallel
seq 1 2 | PARALLEL="-Sparallel\@$SERVER1 -Sssh\ -l\ parallel\ $SERVER2 -j1" parallel -kvv echo

echo '### Test $PARALLEL - multi line'
seq 1 2 | PARALLEL="-Sparallel\@$SERVER1
-Sssh\ -l\ parallel\ $SERVER2
-j1" parallel -kvv echo

echo '### Test ~/.parallel/config - single line'
echo "-Sparallel\@$SERVER1 -Sssh\ -l\ parallel\ $SERVER2 -j1" > ~/.parallel/config
seq 1 2 | parallel -kvv echo

echo '### Test ~/.parallel/config - multi line'
echo "-Sparallel\@$SERVER1
-Sssh\ -l\ parallel\ $SERVER2
-j1" > ~/.parallel/config 
seq 1 2 | parallel -kvv echo
rm ~/.parallel/config
