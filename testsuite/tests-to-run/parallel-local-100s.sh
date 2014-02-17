#!/bin/bash

# Simple jobs that never fails
# Each should be taking >100s and be possible to run in parallel
# I.e.: No race conditions, no logins
cat <<'EOF' | sed -e 's/;$/; /;s/$SERVER1/'$SERVER1'/;s/$SERVER2/'$SERVER2'/' | stdout parallel -k -j4 -L1
echo '### Test if we can deal with output > 4 GB'
##  echo | niceload --io 10 parallel -q perl -e '"\$a=\"x\"x1000000;for(0..4300){print \$a}"' | md5sum
  echo | parallel --tmpdir /dev/shm -q perl -e '$a="x"x1000000;for(0..4300){print $a}' | md5sum

echo '**'

echo "### Test Force outside the file handle limit, 2009-02-17 Gave fork error"
  (echo echo Start; seq 1 20000 | perl -pe 's/^/true /'; echo echo end) | stdout parallel -uj 0 | egrep -v 'processes took|adjusting'

echo '**'

echo '### Test of --retries on unreachable host'
  seq 2 | stdout parallel -k --retries 2 -v -S 4.3.2.1,: echo

echo '**'

EOF
