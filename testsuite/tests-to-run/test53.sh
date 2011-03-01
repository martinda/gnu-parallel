#!/bin/bash

echo '### Test 0-arguments'
seq 1 2 | parallel -k -n0 echo n0
seq 1 2 | parallel -k -L0 echo L0
seq 1 2 | parallel -k -N0 echo N0
echo '### Because of --tollef -l, then -l0 == -l1, sorry'
seq 1 2 | parallel -k -l0 echo l0

echo '### Test replace {}'
seq 1 2 | parallel -k -N0 echo replace {} curlies

echo '### Test arguments on commandline'
parallel -k -N0 echo args on cmdline ::: 1 2
