#!/bin/bash

# Simple jobs that never fails
# Each should be taking 10-30s and be possible to run in parallel
# I.e.: No race conditions, no logins
cat <<'EOF' | sed -e 's/;$/; /;s/$SERVER1/'$SERVER1'/;s/$SERVER2/'$SERVER2'/' | stdout parallel -vj0 -k --joblog /tmp/jl-`basename $0` -L1
EOF
