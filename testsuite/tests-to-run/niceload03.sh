#!/bin/bash

# force load > 10
while uptime | grep -v age:.[1-9]\\+[0-9].[0-9][0-9] >/dev/null ; do (timeout 5 nice burnP6 2>/dev/null &) done

int() {
  perl -pe 's/(\d+\.\d*)/int($1)/e'
}
export -f int

cat <<'EOF' | stdout parallel -k -vj0 -L1
# The seq 30000000 should take > 1 cpu sec to run.
echo '### --soft -f and test if child is actually suspended and thus takes longer'
  niceload --soft -f 0.5 'seq 30000000 | nice wc;echo This should finish last' & 
  (sleep 1; seq 30000000 | nice wc;echo This should finish first) & 
  wait

echo '### niceload with no arguments should give no output'
  niceload

echo '### Test -t and -s'
  # This should sleep at least 2*1s and run 2*2s
  stdout niceload -v -t 1 -s 2 sleep 4.5 | head -n 4

echo 'bug #38908: niceload: Ctrl-C/TERM should resume jobs if using -p - Order may change, but not output'
  # This should take 10 seconds to run + delay from niceload
  # niceload killed after 1 sec => The delay from niceload should be no more than 1 second
  stdout /usr/bin/time -f %e perl -e 'for(1..100) { select(undef, undef, undef, 0.1); } print "done\n"' | int & 
  niceload -vt 1 -s 10 -p $! & 
  export A=$!; 
  sleep 2; 
  kill -s TERM $A; 
  wait; 
  echo Finished

echo 'bug #38908: niceload: Ctrl-C should resume jobs if using -p'
  # This should take 10 seconds to run + delay from niceload
  # niceload killed after 1 sec => The delay from niceload should be no more than 1 second
  stdout /usr/bin/time -f %e perl -e 'for(1..100) { select(undef, undef, undef, 0.1); } print "done\n"' | int & 
  niceload -vt 1 -s 10 -p $! & 
  export A=$!; 
  sleep 2; 
  kill -s INT $A; 
  wait

EOF

# TODO test -f + -t

