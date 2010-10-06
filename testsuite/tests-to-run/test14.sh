#!/bin/bash

# Test -I
seq 1 10 | parallel -k 'seq 1 {} | parallel -k -I :: echo {} ::'

seq 1 10 | parallel -k 'seq 1 {} | parallel -X -k -I :: echo a{} b::'

seq 1 10 | parallel -k 'seq 1 {} | parallel -m -k -I :: echo a{} b::'

seq 1 60000 | parallel -I :: -m echo a::b::c | \
  mop -q "|sort |md5sum" :par
CHAR=$(cat ~/.mop/:par | wc -c)
LINES=$(cat ~/.mop/:par | wc -l)
echo -n "Chars per line ($CHAR/$LINES): "
echo "$CHAR/$LINES" | bc

seq 1 60000 | parallel -I :: -X echo a::b::c | \
  mop -q "|sort |md5sum" :par
CHAR=$(cat ~/.mop/:par | wc -c)
LINES=$(cat ~/.mop/:par | wc -l)
echo -n "Chars per line ($CHAR/$LINES): "
echo "$CHAR/$LINES" | bc
