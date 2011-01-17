#!/bin/bash

# Test -I
seq 1 10 | parallel -k 'seq 1 {} | parallel -k -I :: echo {} ::'

seq 1 10 | parallel -k 'seq 1 {} | parallel -j1 -X -k -I :: echo a{} b::'

seq 1 10 | parallel -k 'seq 1 {} | parallel -j1 -m -k -I :: echo a{} b::'

seq 1 60000 | parallel -I :: -m -j1 echo a::b::c | \
  mop -q "|sort |md5sum" :par
CHAR=$(cat ~/.mop/:par | wc -c)
LINES=$(cat ~/.mop/:par | wc -l)
echo -n "Chars per line ($CHAR/$LINES): "
echo "$CHAR/$LINES" | bc

seq 1 60000 | parallel -I :: -X -j1 echo a::b::c | \
  mop -q "|sort |md5sum" :par
CHAR=$(cat ~/.mop/:par | wc -c)
LINES=$(cat ~/.mop/:par | wc -l)
echo -n "Chars per line ($CHAR/$LINES): "
echo "$CHAR/$LINES" | bc
