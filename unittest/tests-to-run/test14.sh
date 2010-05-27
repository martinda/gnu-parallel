#!/bin/bash

PAR=parallel

# Test -I
seq 1 10 | $PAR -k 'seq 1 {} | '$PAR' -k -I :: echo {} ::'

seq 1 10 | $PAR -k 'seq 1 {} | '$PAR' -X -k -I :: echo a{} b::'

seq 1 10 | $PAR -k 'seq 1 {} | '$PAR' -m -k -I :: echo a{} b::'

seq 1 60000 | $PAR -I :: -m echo a::b::c | \
  mop -q "|sort |md5sum" :par
CHAR=$(cat ~/.mop/:par | wc -c)
LINES=$(cat ~/.mop/:par | wc -l)
echo -n "Chars per line ($CHAR/$LINES): "
echo "$CHAR/$LINES" | bc

seq 1 60000 | $PAR -I :: -X echo a::b::c | \
  mop -q "|sort |md5sum" :par
CHAR=$(cat ~/.mop/:par | wc -c)
LINES=$(cat ~/.mop/:par | wc -l)
echo -n "Chars per line ($CHAR/$LINES): "
echo "$CHAR/$LINES" | bc
