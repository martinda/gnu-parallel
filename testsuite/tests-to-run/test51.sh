#!/bin/bash

echo '### Test --pipe'
# Make some pseudo random input that stays the same
seq 1 1000000 >/tmp/parallel-seq
shuf --random-source=/tmp/parallel-seq /tmp/parallel-seq >/tmp/blocktest

echo '### Test -N with multiple jobslots and multiple args'
seq 1 1 | parallel -j2 -k -N 3 --pipe 'cat;echo a;sleep 0.1'
seq 1 2 | parallel -j2 -k -N 3 --pipe 'cat;echo bb;sleep 0.1'
seq 1 3 | parallel -j2 -k -N 3 --pipe 'cat;echo ccc;sleep 0.1'
seq 1 4 | parallel -j2 -k -N 3 --pipe 'cat;echo dddd;sleep 0.1'
seq 1 5 | parallel -j2 -k -N 3 --pipe 'cat;echo eeeee;sleep 0.1'
seq 1 6 | parallel -j2 -k -N 3 --pipe 'cat;echo ffffff;sleep 0.1'
seq 1 7 | parallel -j2 -k -N 3 --pipe 'cat;echo ggggggg;sleep 0.1'
seq 1 8 | parallel -j2 -k -N 3 --pipe 'cat;echo hhhhhhhh;sleep 0.1'
seq 1 9 | parallel -j2 -k -N 3 --pipe 'cat;echo iiiiiiiii;sleep 0.1'
seq 1 10 | parallel -j2 -k -N 3 --pipe 'cat;echo jjjjjjjjjj;sleep 0.1'

echo '### Test -l -N -L and -n with multiple jobslots and multiple args'
seq 1 5 | parallel -kj2 -l 2 --pipe "cat; echo a; sleep 0.1"
seq 1 5 | parallel -kj2 -N 2 --pipe "cat; echo b; sleep 0.1"
seq 1 5 | parallel -kj2 -L 2 --pipe "cat; echo c; sleep 0.1"
seq 1 5 | parallel -kj2 -n 2 --pipe "cat; echo d; sleep 0.1"

echo '### Test output is the same for different block size'
echo -n 01a02a0a0a12a34a45a6a |
  parallel -k -j1 --blocksize 100 --pipe --recend a  -N 3  'echo -n "$PARALLEL_SEQ>"; cat; echo; sleep 0.1' 
echo -n 01a02a0a0a12a34a45a6a |
  parallel -k -j1 --blocksize 1 --pipe --recend a  -N 3  'echo -n "$PARALLEL_SEQ>"; cat; echo; sleep 0.1' 

# What is this?
#cat /tmp/blocktest <(echo 'a') /tmp/blocktest <(echo 'a') /tmp/blocktest <(echo 'a') /tmp/blocktest <(echo 'a') /tmp/blocktest |
#  parallel -k -j1  --pipe --recend a -N 3  'echo -n "$PARALLEL_SEQ>"; cat; echo; sleep 0.1' | md5sum

echo '### Test 100M records with too big block'
(
 echo start
 seq 1 1 | parallel -uj1 cat /tmp/blocktest\;true
 echo end
 echo start
 seq 1 1 | parallel -uj1 cat /tmp/blocktest\;true
 echo end
 echo start
 seq 1 1 | parallel -uj1 cat /tmp/blocktest\;true
 echo end
) | stdout parallel -k --block 10M -j2 --pipe --recstart 'start\n' wc -c |
egrep -v '^0$'

echo '### Test 300M records with too small block'
(
 echo start
 seq 1 44 | parallel -uj1 cat /tmp/blocktest\;true
 echo end
 echo start
 seq 1 44 | parallel -uj1 cat /tmp/blocktest\;true
 echo end
 echo start
 seq 1 44 | parallel -uj1 cat /tmp/blocktest\;true
 echo end
) | stdout parallel -k --block 200M -j2 --pipe --recend 'end\n' wc -c |
egrep -v '^0$'

echo '### Test --rrs -N1 --recend single'
echo 12a34a45a6 |
  parallel -k --pipe --recend a -N1 --rrs 'echo -n "$PARALLEL_SEQ>"; cat; echo; sleep 0.1'
# Broken
#echo '### Test --rrs -N1 --recend alternate'
#echo 12a34b45a6 |
#  parallel -k --pipe --recend 'a|b' -N1 --rrs 'echo -n "$PARALLEL_SEQ>"; cat; echo; sleep 0.1'
echo '### Test --rrs -N1 --recend single'
echo 12a34b45a6 |
  parallel -k --pipe --recend 'b' -N1 --rrs 'echo -n "$PARALLEL_SEQ>"; cat; echo; sleep 0.1'

echo '### Test --rrs --recend single'
echo 12a34a45a6 |
  parallel -k --pipe --recend a --rrs 'echo -n "$PARALLEL_SEQ>"; cat; echo; sleep 0.1'
# Broken
#echo '### Test --rrs -N1 --recend alternate'
#echo 12a34b45a6 |
#  parallel -k --pipe --recend 'a|b' --rrs 'echo -n "$PARALLEL_SEQ>"; cat; echo; sleep 0.1'
echo '### Test --rrs -N1 --recend single'
echo 12a34b45a6 |
  parallel -k --pipe --recend 'b' --rrs 'echo -n "$PARALLEL_SEQ>"; cat; echo; sleep 0.1'

echo '### Test -N even'
seq 1 10 | parallel -j2 -k -N 2 --pipe cat";echo ole;sleep 0.\$PARALLEL_SEQ"

echo '### Test -N odd'
seq 1 11 | parallel -j2 -k -N 2 --pipe cat";echo ole;sleep 0.\$PARALLEL_SEQ"

echo '### Test -N even+2'
seq 1 12 | parallel -j2 -k -N 2 --pipe cat";echo ole;sleep 0.\$PARALLEL_SEQ"

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

