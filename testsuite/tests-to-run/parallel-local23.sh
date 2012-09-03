#!/bin/bash

rm -rf tmp 2>/dev/null
cp -a input-files/testdir2 tmp
cd tmp

echo '### Test filenames containing UTF-8'
find . -name '*.jpg' | parallel -j +0 convert -geometry 120 {} {//}/thumb_{/}

find |grep -v CVS | sort

cd ..
rm -rf tmp
