#!/bin/bash

SERVER1=parallel-server3
SERVER2=parallel-server2

echo '### Test $PARALLEL - single line'
echo | PARALLEL=--number-of-cpus parallel
(echo 1; echo 1) | PARALLEL="-Sparallel\@$SERVER1 -Sssh\ -l\ parallel\ $SERVER2 -j1" parallel -kv hostname\; echo | sort

echo '### Test $PARALLEL - multi line'
(echo 1; echo 1) | PARALLEL="-Sparallel\@$SERVER1
-Sssh\ -l\ parallel\ $SERVER2
-j1" parallel -kv hostname\; echo | sort

echo '### Test ~/.parallel/config - single line'
echo "-Sparallel\@$SERVER1 -Sssh\ -l\ parallel\ $SERVER2 -j1" > ~/.parallel/config
(echo 1; echo 1) | parallel -kv hostname\; echo | sort

echo '### Test ~/.parallel/config - multi line'
echo "-Sparallel\@$SERVER1
-Sssh\ -l\ parallel\ $SERVER2
-j1" > ~/.parallel/config 
(echo 1; echo 1) | parallel -kv hostname\; echo | sort
rm ~/.parallel/config
