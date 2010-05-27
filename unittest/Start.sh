#!/bin/bash

SHFILE=/tmp/unittest-parallel.sh

ls -t tests-to-run/test*.sh \
| perl -pe 's:(.*/(.*)).sh:sh $1.sh > actual-results/$2; diff -Naur wanted-results/$2 actual-results/$2:' \
>$SHFILE

sh -x $SHFILE
rm $SHFILE



