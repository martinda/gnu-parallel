#!/bin/bash

echo '### Test niceload'
niceload -s 1 perl -e '$|=1;do{$l==$r or print "."; $l=$r}until(($r=time-$^T)>10)'
echo 

#echo '### Test niceload -p'
#sleep 3 &
#nice-load -v -p $!


