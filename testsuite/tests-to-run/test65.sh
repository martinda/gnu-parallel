#!/bin/bash

# -L1 will join lines ending in ' '
cat <<'EOF' | sed -e s/\$SERVER1/$SERVER1/\;s/\$SERVER2/$SERVER2/ | parallel -vj10 -k --joblog /tmp/jl-`basename $0` -L1
echo "### Test memory consumption stays (almost) the same for 30 and 300 jobs"
  mem30=$( stdout time -f %M parallel -j2 true :::: <(perl -e '$a="x"x100000;for(1..30){print $a,"\n"}') ); 
  mem300=$( stdout time -f %M parallel -j2 true :::: <(perl -e '$a="x"x100000;for(1..300){print $a,"\n"}') ); 
  echo "Memory use should not depend very much on the total number of jobs run\n"; 
  echo "Test if memory consumption(300 jobs) < memory consumption(30 jobs) * 110% "; 
  echo $(($mem300*100 < $mem30 * 110))

echo '### Test --shellquote'
  perl -e 'print pack("c*",1..255)' | parallel -0 --shellquote

EOF
