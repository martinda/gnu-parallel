#!/bin/bash

PAR=parallel

# This causes problems if we kill child processes
seq 1 40 | $PAR -j 0 seq 1 10  | sort |md5sum
seq 1 40 | $PAR -j 0 seq 1 10 '| '$PAR' -j 3 echo' | sort |md5sum

# Test of xargs
seq 1 60000 | $PAR -m echo  | mop -d 4 "|sort |md5sum" "| wc"
(echo foo;echo bar) | $PAR -m echo 1{}2{}3 A{}B{}C
(echo foo;echo bar) | $PAR -X echo 1{}2{}3 A{}B{}C
seq 1 60000 | $PAR -m echo a{}b{}c | mop -d 4 "|sort |md5sum" "| wc"
seq 1 60000 | $PAR -m echo a{}b{}c | \
  mop -q "|sort |md5sum" :par
echo -n "Chars per line: "
CHAR=$(cat ~/.mop/:par | wc -c)
LINES=$(cat ~/.mop/:par | wc -l)
echo "$CHAR/$LINES" | bc

# Bug before 2009-08-26 causing regexp compile error or infinite loop
echo a | $PAR -qX echo  "'"{}"' "
echo a | $PAR -qX echo  "'{}'"
