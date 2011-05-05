#!/bin/bash

echo '### Test :::: mixed with :::'
echo '### Test :::: < ::: :::'
parallel -k echo {1} {2} {3} :::: <(seq 6 7) ::: 4 5 ::: 1 2 3

echo '### Test :::: <  < :::: <'
parallel -k echo {1} {2} {3} :::: <(seq 6 7) <(seq 4 5) :::: <(seq 1 3)

echo '### Test -a ::::  < :::: <'
parallel -k -a <(seq 6 7) echo {1} {2} {3} :::: <(seq 4 5) :::: <(seq 1 3)

echo '### Test -a -a :::'
parallel -k -a <(seq 6 7) -a <(seq 4 5) echo {1} {2} {3} ::: 1 2 3

echo '### Test -a - -a :::'
seq 6 7 | parallel -k -a - -a <(seq 4 5) echo {1} {2} {3} ::: 1 2 3

echo '### Test :::: < - :::'
seq 4 5 | parallel -k echo {1} {2} {3} :::: <(seq 6 7) - ::: 1 2 3
