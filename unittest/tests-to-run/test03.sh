#!/bin/bash

PAR=parallel

rm -rf tmp 2>/dev/null
cp -a input-files/testdir2 tmp
cd tmp

# tests if -c (cat | sh) works
perl -e 'for(1..25) {print "echo a $_; echo b $_\n"}' | $PAR -c 2>&1 | sort

cd ..
rm -rf tmp
