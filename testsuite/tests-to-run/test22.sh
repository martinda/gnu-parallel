#!/bin/bash

PAR=parallel
SERVER1=parallel-server1
SERVER2=parallel-server2

(
echo '### Test exit val'
echo true | parallel
echo $?
echo false | parallel
echo $?

echo '### Test --halt-on-error'
(echo "sleep 1;true"; echo "sleep 2;false";echo "sleep 3;true") | parallel -j10 --halt-on-error 0
echo $?
(echo "sleep 1;true"; echo "sleep 2;false";echo "sleep 3;true") | parallel -j10 --halt-on-error 1
echo $?
(echo "sleep 1;true"; echo "sleep 2;false";echo "sleep 3;true") | parallel -j10 --halt-on-error 2
echo $?

(echo "sleep 1;true"; echo "sleep 2;false";echo "sleep 3;true";echo "sleep 4; non_exist") | parallel -j10 -H0
echo $?
(echo "sleep 1;true"; echo "sleep 2;false";echo "sleep 3;true";echo "sleep 4; non_exist") | parallel -j10 -H1
echo $?
(echo "sleep 1;true"; echo "sleep 2;false";echo "sleep 3;true";echo "sleep 4; non_exist") | parallel -j10 -H2
echo $?

echo '### Test last dying print --halt-on-error'
(seq 0 8;echo 0; echo 9) | parallel -j10 -kqH1 perl -e 'sleep $ARGV[0];print STDERR @ARGV,"\n"; exit shift'
echo $?
(seq 0 8;echo 0; echo 9) | parallel -j10 -kqH2 perl -e 'sleep $ARGV[0];print STDERR @ARGV,"\n"; exit shift'
echo $?
) 2>&1
