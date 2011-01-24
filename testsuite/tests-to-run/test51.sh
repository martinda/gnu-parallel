#!/bin/bash

echo '### Test --pipe'
# Make some pseudo random input that stays the same
seq 1 1000000 >/tmp/parallel-seq
shuf --random-source=/tmp/parallel-seq /tmp/parallel-seq >/tmp/blocktest

echo '### Test -N even'
seq 1 10 | parallel -j2 -k -N 2 --pipe cat";echo ole;sleep 0.1"

echo '### Test -N odd'
seq 1 11 | parallel -j2 -k -N 2 --pipe cat";echo ole;sleep 0.1"

echo '### Test -N even+2'
seq 1 12 | parallel -j2 -k -N 2 --pipe cat";echo ole;sleep 0.1"

echo '### Test --recstart + --recend'
cat /tmp/blocktest | parallel -k --recstart 44 --recend "44" -j10 --pipe sort -n |md5sum

echo '### Race condition bug - 1 - would block'
seq 1 80  | nice parallel -j0 'seq 1 10| parallel --block 1 --recend "" --pipe cat;true' >/dev/null

echo '### Race condition bug - 2 - would block'
seq 1 100 | nice parallel -j100 --block 1 --recend "" --pipe cat >/dev/null

echo '### Test --block size=1'
seq 1 10| parallel --block 1 --files --recend ""  --pipe sort -n | parallel -Xj1 sort -nm {} ";"rm {} 

echo '### Test --block size=1M -j10 --files - more jobs than data'
sort -n < /tmp/blocktest | md5sum
cat /tmp/blocktest | parallel --files --recend "\n" -j10 --pipe sort -n | parallel -Xj1 sort -nm {} ";"rm {} | md5sum

echo '### Test --block size=1M -j1 - more data than cpu'
cat /tmp/blocktest | parallel --files --recend "\n" -j1 --pipe sort -n | parallel -Xj1 sort -nm {} ";"rm {} | md5sum

echo '### Test --block size=1M -j1 - more data than cpu'
cat /tmp/blocktest | parallel --files --recend "\n" -j2 --pipe sort -n | parallel -Xj1 sort -nm {} ";"rm {} | md5sum

echo '### Test --pipe default settings'
cat /tmp/blocktest | parallel --pipe sort | sort -n | md5sum

