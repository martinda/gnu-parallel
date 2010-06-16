#!/bin/bash

echo '### 64-bit wierdness - this did not complete on a 64-bit machine'
seq 1 2 | parallel -j1 'seq 1 1 | parallel true'
