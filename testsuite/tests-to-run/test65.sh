#!/bin/bash

# -L1 will join lines ending in ' '
cat <<'EOF' | sed -e s/\$SERVER1/$SERVER1/\;s/\$SERVER2/$SERVER2/ | parallel -j10 -k -L1
echo '### Test --timeout'; 
  parallel -j0 -k --timeout 1 echo {}\; sleep {}\; echo {} ::: 1.1 2.2 3.3 4.4
EOF
