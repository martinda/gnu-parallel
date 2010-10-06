#!/bin/bash

# Test if we can deal with output > 4 GB
echo | niceload -l=1.5 parallel -q perl -e '$a="x"x1000000;for(0..4300){print $a}' | md5sum
# dd does not work with niceload (no idea why)
#echo | parallel 'dd if=/dev/zero count=43 bs=100000k; echo 1; echo 2' | md5sum
