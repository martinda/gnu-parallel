#!/bin/bash

# Simple jobs that never fails
# Each should be taking 0.3-1s and be possible to run in parallel
# I.e.: No race conditions, no logins
cat <<'EOF' | sed -e 's/;$/; /;s/$SERVER1/'$SERVER1'/;s/$SERVER2/'$SERVER2'/' | stdout parallel -k -j4 -L1
echo '### Test exit val - true'; 
  echo true | parallel; 
  echo $?

echo '**'

echo '### Test exit val - false'; 
  echo false | parallel; 
  echo $?

echo '**'

EOF
