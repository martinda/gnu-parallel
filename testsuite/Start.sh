#!/bin/bash

# Argument can be substring of tests (such as 'local')

export LANG=C
SHFILE=/tmp/unittest-parallel.sh
MAX_SEC_PER_TEST=900
export TIMEOUT=$MAX_SEC_PER_TEST

if [ "$TRIES" = "3" ] ; then
  # Try a failing test thrice
  echo Retrying 3 times
  ls -t tests-to-run/*${1}*.sh |
    grep -v ${2} |
    perl -pe 's:(.*/(.*)).sh:bash $1.sh > actual-results/$2; diff -Naur wanted-results/$2 actual-results/$2 >/dev/null || bash $1.sh > actual-results/$2; diff -Naur wanted-results/$2 actual-results/$2 >/dev/null || bash $1.sh > actual-results/$2; diff -Naur wanted-results/$2 actual-results/$2 || touch $1.sh: ' \
    >$SHFILE
else
  # Run a failing test once
  echo Not retrying
  ls -t tests-to-run/*${1}*.sh |
    grep -v ${2} |
    perl -pe 's:(.*/(.*)).sh:bash $1.sh > actual-results/$2; diff -Naur wanted-results/$2 actual-results/$2 || touch $1.sh:' \
    >$SHFILE
fi

date
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
date
