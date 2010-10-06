#!/bin/bash

PAR=parallel

rm -rf tmp 2>/dev/null
cp -a input-files/testdir2 tmp
cd tmp

echo '### Test filenames containing UTF-8'
find . -name '*.jpg' | $PAR -j +0 convert -geometry 120 {} {}_thumb.jpg
find . -name '*_thumb.jpg' | ren 's:/([^/]+)_thumb.jpg$:/thumb_$1:'

find |grep -v CVS | sort

cd ..
rm -rf tmp
