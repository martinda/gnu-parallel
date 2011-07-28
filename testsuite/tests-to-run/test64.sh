#!/bin/bash

SERVER1=parallel-server3
SERVER2=parallel-server2

# -L1 will join lines ending in ' '
cat <<'EOF' | sed -e s/\$SERVER1/$SERVER1/\;s/\$SERVER2/$SERVER2/ | parallel -j10 -k -L1
echo '### Test -k 5'; 
  sleep 5

echo '### Test -k 3'; 
  sleep 3

echo '### Test -k 4'; 
  sleep 4

echo '### Test -k 2'; 
  sleep 2

echo '### Test -k 1'; 
  sleep 1
EOF
