#!/bin/bash

cd input-files/test08

ls \
| parallel -q  perl -ne '/_PRE (\d+)/ and $p=$1; /hatchname> (\d+)/ and $1!=$p and print $ARGV,"\n"' \
| sort

seq 1 10 | parallel -j 1 echo | sort
seq 1 10 | parallel -j 2 echo | sort
seq 1 10 | parallel -j 3 echo | sort

