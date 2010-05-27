#!/bin/bash

PAR=parallel

rm -rf tmp 2>/dev/null
cp -a input-files/testdir2 tmp
cd tmp

find . -name '*.jpg' | $PAR -j +0 convert -geometry 120 {} {}_thumb.jpg
find . -name '*_thumb.jpg' | ren 's:/([^/]+)_thumb.jpg$:/thumb_$1:'

find |grep -v CVS

cd ..
rm -rf tmp
