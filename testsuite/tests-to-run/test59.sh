#!/bin/bash

echo '### Test bug https://savannah.gnu.org/bugs/index.php?33352'

# produce input slowly to parallel so that it will reap a process
# while blocking in read()

# Having found the solution it is suddenly very easy to reproduce the
# problem - even on other hardware:
#
# perl -e '@x=1 .. 17000; for(1..30) { print "@x\n"}' | pv -qL 200000
# |parallel -j2 --pipe --keeporder --block 150000 cat | md5sum
#
# This gives different md5sums for each run.
#
# The problem is that read(STDIN) is being interrupted by a dead
# child. The chance of this happening is very small if there are few
# children dying or read(STDIN) never has to wait for data.
#
# The test above forces data to arrive slowly (using pv) which causes
# read(STDIN) to take a long time - thus being interrupted by a dead
# child.

MD5=md5sum
PAR="parallel -j2 --pipe --keeporder --block 150000 --tmpdir=/dev/shm"
perl -e '@x=1 .. 17000; for(1..100) { print "@x\n"}' | md5sum
nice nice perl -e '@x=1 .. 17000; for(1..100) { print "@x\n"}' | pv -qL 1000000 | \
  $PAR cat | md5sum &
nice nice perl -e '@x=1 .. 17000; for(1..100) { print "@x\n"}' | pv -qL 1000000 | \
  $PAR --recend '' cat | md5sum &
nice nice perl -e '@x=1 .. 17000; for(1..100) { print "@x\n"}' | pv -qL 1000000 | \
  $PAR --recend '' --files cat | parallel -Xj1 cat {}';'rm {} | md5sum &
nice nice perl -e '@x=1 .. 17000; for(1..100) { print "@x\n"}' | pv -qL 1000000 | \
  $PAR --recend '' --files cat | parallel -Xj1 cat {}';'rm {} | md5sum &
nice nice perl -e '@x=1 .. 17000; for(1..100) { print "@x\n"}' | pv -qL 1000000 | \
  $PAR --recend '' --files --tmpdir /dev/shm cat | parallel -Xj1 cat {}';'rm {} | md5sum &
nice nice perl -e '@x=1 .. 17000; for(1..100) { print "@x\n"}' | pv -qL 1000000 | \
  $PAR --recend '' --files --halt-on-error 2 cat | parallel -Xj1 cat {}';'rm {} | md5sum &
wait



