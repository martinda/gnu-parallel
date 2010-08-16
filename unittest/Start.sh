#!/bin/bash

export LANG=C
SHFILE=/tmp/unittest-parallel.sh

ls -t tests-to-run/*.sh \
| perl -pe 's:(.*/(.*)).sh:bash $1.sh > actual-results/$2; diff -Naur wanted-results/$2 actual-results/$2:' \
>$SHFILE

mkdir -p actual-results
sh -x $SHFILE
rm $SHFILE



