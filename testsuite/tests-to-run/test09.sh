#!/bin/bash

# Simple jobs taking 100s that can be run in parallel
cat <<'EOF' | sed -e s/\$SERVER1/$SERVER1/\;s/\$SERVER2/$SERVER2/ | parallel -j0 -k -L1
echo "### Test Force outside the file handle limit, 2009-02-17 Gave fork error"; 
  (echo echo Start; seq 1 20000 | perl -pe 's/^/true /'; echo echo end) | parallel -uj 0 
EOF

