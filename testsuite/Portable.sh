#!/bin/bash

export LANG=C
SHFILE=/tmp/unittest-parallel.sh

# These tests seem to work on another machine
ls -t tests-to-run/test{01,03,04,05,06,07,08,09,11,15,22,24,25,26,28,29,31,33,34,39,40,43,49,52,53,54}.sh \
tests-to-run/niceload01.sh tests-to-run/sem01.sh \
| perl -pe 's:(.*/(.*)).sh:bash $1.sh > actual-results/$2; diff -Naur wanted-results/$2 actual-results/$2:' \
>$SHFILE

mkdir -p actual-results
sh -x $SHFILE
rm $SHFILE
