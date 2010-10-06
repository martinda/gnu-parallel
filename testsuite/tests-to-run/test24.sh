#!/bin/bash

echo '### 64-bit wierdness - this did not complete on a 64-bit machine'
seq 1 2 | parallel -j1 'seq 1 1 | parallel true'

echo "### BUG-fix: bash -c 'parallel -a <(seq 1 3) echo'"
stdout bash -c 'parallel -k -a <(seq 1 3)  echo'

echo "### BUG: The length for -X is not close to max (131072)"
seq 1 60000 | parallel -X echo {.} aa {}{.} {}{}d{} {}dd{}d{.} |head -n 1 |wc
seq 1 60000 | parallel -X echo a{}b{}c |head -n 1 |wc
seq 1 60000 | parallel -X echo |head -n 1 |wc
seq 1 60000 | parallel -X echo a{}b{}c {} |head -n 1 |wc
seq 1 60000 | parallel -X echo {}aa{} |head -n 1 |wc
seq 1 60000 | parallel -X echo {} aa {} |head -n 1 |wc
