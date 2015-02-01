#!/bin/bash

# Simple jobs that never fails
# Each should be taking 30-100s and be possible to run in parallel
# I.e.: No race conditions, no logins

# Assume /tmp/shm is easy to fill up
export SHM=/tmp/shm/parallel
mkdir -p $SHM
sudo umount -l $SHM
sudo mount -t tmpfs -o size=10% none $SHM

cat <<'EOF' | sed -e 's/;$/; /;s/$SERVER1/'$SERVER1'/;s/$SERVER2/'$SERVER2'/' | stdout parallel -vj4 -k --joblog /tmp/jl-`basename $0` -L1
echo '### Test race condition on 8 CPU (my laptop)'; 
  seq 1 5000000 > /tmp/parallel_test; 
  seq 1 10 | parallel -k "cat /tmp/parallel_test | parallel --pipe --recend '' -k gzip >/dev/null; echo {}"; 
  rm /tmp/parallel_test

echo '**'

echo "### Test --tmpdir running full. bug #40733 was caused by this"
  stdout parallel -j1 --tmpdir $SHM cat /dev/zero ::: dummy

echo '**'


EOF
