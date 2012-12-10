#!/bin/bash

# force load > 10
while uptime | grep -v age:.[1-9][0-9].[0-9][0-9] >/dev/null ; do (timeout 5 nice burnP6 2>/dev/null &) done

cat <<'EOF' | stdout parallel -j0 -L1
echo '### --soft -f and test if child is actually suspended and thus takes longer'
  niceload --soft -t 0.2 -f 0.5 'seq 1000000 | wc;echo This should finish last'
  (sleep 1; seq 1000000 | wc;echo This should finish first)
echo '### niceload with no arguments should give no output'
  niceload
EOF

