#!/bin/bash

# Argument can be substring of tests (such as 'local')

export LANG=C
SHFILE=/tmp/unittest-parallel.sh

# Run a failing test once
ls -t tests-to-run/*${1}*.sh \
| perl -pe 's:(.*/(.*)).sh:bash $1.sh > actual-results/$2; diff -Naur wanted-results/$2 actual-results/$2: ' \
>$SHFILE

#  # Try a failing test thrice
#  ls -t tests-to-run/*${1}*.sh \
#  | perl -pe 's:(.*/(.*)).sh:bash $1.sh > actual-results/$2; diff -Naur wanted-results/$2 actual-results/$2 >/dev/null || bash $1.sh > actual-results/$2; diff -Naur wanted-results/$2 actual-results/$2 >/dev/null || bash $1.sh > actual-results/$2; diff -Naur wanted-results/$2 actual-results/$2: ' \
#  >$SHFILE


mkdir -p actual-results
stdout sh -x $SHFILE | tee testsuite.log
rm $SHFILE
# If testsuite.log contains @@ then there is a diff
if grep -q '@@' testsuite.log ; then
  false
else
  # No @@'s: So everything worked: Copy the source
  rm -rf src-passing-testsuite
  cp -a ../src src-passing-testsuite
fi
rm testsuite.log

