#!/bin/bash

highload ()
{
  # Force load > #cpus
  CPUS=$(parallel --number-of-cores)
  seq 0 0.1 $CPUS | parallel -j0 timeout 50 burnP6 2>/dev/null &
  PID=$!
  sleep 20
  perl -e 'do{$a=`uptime`} while($a=~/average: *(\S+)/ and $1 < '$CPUS')'
  # Load is now > $CPUS
  # Kill off burnP6 and the parent parallel
#  kill $PID; sleep 0.1; kill $PID; killall burnP6; sleep 0.3; kill -9 $PID 2>/dev/null
}

highload 2>/dev/null &
sleep 1

cat <<'EOF' | parallel -j0 -k -L1
echo "bug #38441: CPU usage goes to 100% if load is higher than --load at first job"
/usr/bin/time -f %e parallel --load 100% true ::: a 2>&1 | 
  perl -ne '$_ > 1 and print "More than 1 secs wall clock: OK\n"'

/usr/bin/time -f %U parallel --load 100% true ::: a 2>&1 | 
  perl -ne '$_ < 1 and print "Less than 1 secs user time: OK\n"'

echo '### Test slow arguments generation - https://savannah.gnu.org/bugs/?32834'
  seq 1 3 | parallel -j1 "sleep 2; echo {}" | parallel -kj2 echo

echo '### Test too slow spawning - TODO THIS CURRENTLY DOES NOT OVERLOAD'
# Let the commands below run during high load
seq `parallel --number-of-cores` | parallel -j200% -N0 timeout -k 25 26 burnP6 & 
  sleep 1; 
  seq 1 1000 | stdout nice nice  parallel -s 100 -uj0 true | 
  perl -pe '/parallel: Warning: Starting \d+ processes took/ and do {close STDIN; `killall -9 burnP6`; print "OK\n"; exit }'
EOF

# Make sure we got all the burnP6 killed
killall -9 burnP6 2>/dev/null
