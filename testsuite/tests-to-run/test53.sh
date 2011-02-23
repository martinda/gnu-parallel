#!/bin/bash

echo '### Test 0-arguments'
seq 1 2 | parallel -n0 echo n0
seq 1 2 | parallel -L0 echo L0
seq 1 2 | parallel -l0 echo l0
seq 1 2 | parallel -N0 echo N0

echo '### Test replace {}'
seq 1 2 | parallel -N0 echo replace {} curlies

echo '### Test arguments on commandline'
parallel -N0 echo args on cmdline ::: 1 2
