#!/bin/bash

# force load > 10
while uptime | grep -v age:.[1-9][0-9].[0-9][0-9] >/dev/null ; do (timeout 5 nice burnP6 2>/dev/null &) done

cat <<'EOF' | stdout parallel -j0 -L1
# The seq 10000000 should take > 1 cpu sec to run.
echo '### --soft -f and test if child is actually suspended and thus takes longer'
  niceload --soft -f 0.5 'seq 20000000 | wc;echo This should finish last'
  (sleep 1; seq 20000000 | wc;echo This should finish first)
echo '### niceload with no arguments should give no output'
  niceload
EOF

# TODO test -f + -t

