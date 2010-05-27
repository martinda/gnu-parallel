#!/bin/bash

PAR=parallel

cd input-files/test08

ls \
| $PAR -q  perl -ne '/_PRE (\d+)/ and $p=$1; /hatchname> (\d+)/ and $1!=$p and print $ARGV,"\n"' \
| sort

seq 1 10 | $PAR -j 1 echo | sort
seq 1 10 | $PAR -j 2 echo | sort
seq 1 10 | $PAR -j 3 echo | sort

