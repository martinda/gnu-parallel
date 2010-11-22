#!/bin/bash

PAR=parallel

rm -rf tmp 2>/dev/null
cp -a input-files/testdir2 tmp
cd tmp

# tests if cat | sh-mode works
perl -e 'for(1..25) {print "echo a $_; echo b $_\n"}' | $PAR 2>&1 | sort

# tests if xargs-mode works
perl -e 'for(1..25) {print "a $_\nb $_\n"}' | $PAR echo 2>&1 | sort

cd ..
rm -rf tmp
