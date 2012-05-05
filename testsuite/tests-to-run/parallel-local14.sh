#!/bin/bash

# Assume /dev/shm is easy to fill up
mkdir -p /dev/shm/parallel

echo '### Test $TMPDIR'
TMPDIR=/dev/shm/parallel stdout timeout -k 1 6 parallel head -c 2000m '<'{} >/dev/null ::: /dev/zero &
seq 1 200 | parallel -j1 "df /dev/shm | parallel -k --colsep ' +' echo {4}|tail -n 1;sleep 0.1" \
| stdout timeout -k 1 10 perl -ne 'BEGIN{$a=<>} $b=<>; if ($a-1000 > $b) { print "More than 1 MB gone. Good!\n"; exit }'
wait
sleep 0.1

echo '### Test --tmpdir'
stdout timeout -k 1 6 parallel --tmpdir /dev/shm/parallel head -c 2000m '<'{} >/dev/null ::: /dev/zero &
seq 1 200 | parallel -j1 "df /dev/shm | parallel -k --colsep ' +' echo {4}|tail -n 1;sleep 0.1" \
| stdout timeout -k 1 10 perl -ne 'BEGIN{$a=<>} $b=<>; if ($a-1000 > $b) { print "More than 1 MB gone. Good!\n"; exit }'
wait
sleep 0.1

echo '### Test $TMPDIR and --tmpdir'
TMPDIR=/tmp stdout timeout -k 1 6 parallel --tmpdir /dev/shm/parallel head -c 2000m '<'{} >/dev/null ::: /dev/zero &
seq 1 200 | parallel -j1 "df /dev/shm | parallel -k --colsep ' +' echo {4}|tail -n 1;sleep 0.1" \
| stdout timeout -k 1 10 perl -ne 'BEGIN{$a=<>} $b=<>; if ($a-1000 > $b) { print "More than 1 MB gone. Good!\n"; exit }'
wait
sleep 0.1
