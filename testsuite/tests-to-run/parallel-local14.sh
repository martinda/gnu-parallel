#!/bin/bash

# Assume /dev/shm is easy to fill up
SHM=/tmp/shm/parallel
mkdir -p $SHM
sudo umount -l $SHM
sudo mount -t tmpfs -o size=10% none $SHM

echo '3 x terminated is OK' >&2
echo '### Test $TMPDIR'
TMPDIR=$SHM stdout timeout -k 1 6 parallel pv -qL10m {} ::: /dev/zero >/dev/null &
PID=$!
seq 1 200 | parallel -j1 "df $SHM | parallel -k --colsep ' +' echo {4}|tail -n 1;sleep 0.1" \
| stdout timeout -k 1 10 perl -ne 'BEGIN{$a=<>} $b=<>; 
if ($a-1000 > $b) { print "More than 1 MB gone. Good!\n";exit }'
kill $PID
wait
sleep 0.1

echo '### Test --tmpdir'
stdout timeout -k 1 6 parallel --tmpdir $SHM pv -qL10m {} ::: /dev/zero >/dev/null &
PID=$!
seq 1 200 | parallel -j1 "df $SHM | parallel -k --colsep ' +' echo {4}|tail -n 1;sleep 0.1" \
| stdout timeout -k 1 10 perl -ne 'BEGIN{$a=<>} $b=<>; if ($a-1000 > $b) { print "More than 1 MB gone. Good!\n"; exit }'
kill $PID
wait
sleep 0.1

echo '### Test $TMPDIR and --tmpdir'
TMPDIR=/tmp stdout timeout -k 1 6 parallel --tmpdir $SHM pv -qL10m {} ::: /dev/zero >/dev/null &
PID=$!
seq 1 200 | parallel -j1 "df $SHM | parallel -k --colsep ' +' echo {4}|tail -n 1;sleep 0.1" \
| stdout timeout -k 1 10 perl -ne 'BEGIN{$a=<>} $b=<>; if ($a-1000 > $b) { print "More than 1 MB gone. Good!\n"; exit }'
kill $PID
wait
sleep 0.1
