#!/bin/bash

echo '### Test distribute arguments at EOF to 2 jobslots'
seq 1 92 | parallel -j+0 -kX -s 100 echo

echo '### Test distribute arguments at EOF to 5 jobslots'
seq 1 92 | parallel -j+3 -kX -s 100 echo

echo '### Test distribute arguments at EOF to infinity jobslots'
seq 1 92 | parallel -j0 -kX -s 100 echo

echo '### Test -N is not broken by distribution - single line'
seq 9 | parallel  -N 10  echo

echo '### Test -N is not broken by distribution - two lines'
seq 19 | parallel  -N 10  echo




