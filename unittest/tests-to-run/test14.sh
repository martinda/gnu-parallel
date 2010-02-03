#!/bin/bash

# Test -I
seq 1 10 | parallel -k 'seq 1 {} | parallel -k -I :: echo {} ::'

seq 1 10 | parallel -k 'seq 1 {} | parallel -X -k -I :: echo a{} b::'

seq 1 10 | parallel -k 'seq 1 {} | parallel -m -k -I :: echo a{} b::'

seq 1 60000 | parallel -I :: -m echo a::b::c | \
  mop -q "|sort |md5sum" :parallel
echo -n "Chars per line: "
CHAR=$(cat ~/.mop/:parallel | wc -c)
LINES=$(cat ~/.mop/:parallel | wc -l)
echo "$CHAR/$LINES" | bc

seq 1 60000 | parallel -I :: -X echo a::b::c | \
  mop -q "|sort |md5sum" :parallel
echo -n "Chars per line: "
CHAR=$(cat ~/.mop/:parallel | wc -c)
LINES=$(cat ~/.mop/:parallel | wc -l)
echo "$CHAR/$LINES" | bc
