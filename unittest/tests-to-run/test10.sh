#!/bin/bash

# This causes problems if we kill child processes
seq 1 40 | parallel -j 0 seq 1 10  | sort |md5sum
seq 1 40 | parallel -j 0 seq 1 10 '| parallel -j 3 echo' | sort |md5sum

# Test of xargs
seq 1 60000 | parallel -x echo  | mop -d 4 "|sort |md5sum" "| wc" 
(echo foo;echo bar) | parallel -x echo 1{}2{}3 A{}B{}C
(echo foo;echo bar) | parallel -X echo 1{}2{}3 A{}B{}C
seq 1 60000 | parallel -x echo 1{}2{}3 | mop -d 4 "|sort |md5sum" "| wc" 
seq 1 60000 | parallel -x echo 1{}2{}3 | \
  mop -q "|sort |md5sum" :parallel
echo -n "Chars per line: "
CHAR=$(cat ~/.mop/:parallel | wc -c)
LINES=$(cat ~/.mop/:parallel | wc -l)
echo "$CHAR/$LINES" | bc
