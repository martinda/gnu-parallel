#!/bin/bash

echo '### This causes problems if we kill child processes'
seq 1 40 | parallel -j 0 seq 1 10  | sort |md5sum
seq 1 40 | parallel -j 0 seq 1 10 '| parallel -j 3 echo' | sort |md5sum

echo '### Test of xargs -m and -X'
seq 1 60000 | parallel -j1 -m echo  | mop -d 4 "|sort |md5sum" "| wc"
(echo foo;echo bar) | parallel -j1 -m echo 1{}2{}3 A{}B{}C
(echo foo;echo bar) | parallel -j1 -X echo 1{}2{}3 A{}B{}C
seq 1 60000 | parallel -m -j1 echo a{}b{}c | mop -d 4 "|sort |md5sum" "| wc"
seq 1 60000 | parallel -m -j1 echo a{}b{}c | \
  mop -q "|sort |md5sum" :par
echo -n "Chars per line: "
CHAR=$(cat ~/.mop/:par | wc -c)
LINES=$(cat ~/.mop/:par | wc -l)
echo "$CHAR/$LINES" | bc

echo '### Bug before 2009-08-26 causing regexp compile error or infinite loop'
echo a | parallel -qX echo  "'"{}"' "
echo a | parallel -qX echo  "'{}'"
