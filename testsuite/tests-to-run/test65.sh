#!/bin/bash

# -L1 will join lines ending in ' '
cat <<'EOF' | sed -e s/\$SERVER1/$SERVER1/\;s/\$SERVER2/$SERVER2/ | parallel -j10 -k -L1
echo '### Test --timeout'; 
  parallel -j0 -k --timeout 1 echo {}\; sleep {}\; echo {} ::: 1.1 2.2 3.3 4.4
echo '### Test retired'; 
  stdout parallel -B; 
  stdout parallel -g; 
  stdout parallel -H; 
  stdout parallel -T; 
  stdout parallel -U; 
  stdout parallel -W; 
  stdout parallel -Y;
echo '### Test --joblog followed by --resume --joblog'; 
  rm -f /tmp/joblog; 
  timeout -k 1 1 parallel -j2 --joblog /tmp/joblog sleep {} ::: 1.1 2.2 3.3 4.4 2>/dev/null; 
  parallel -j2 --resume --joblog /tmp/joblog sleep {} ::: 1.1 2.2 3.3 4.4; 
  cat /tmp/joblog | wc; 
  rm -f /tmp/joblog;
echo '### Test --resume --joblog followed by --resume --joblog'; 
  rm -f /tmp/joblog2; 
  timeout -k 1 1 parallel -j2 --resume --joblog /tmp/joblog2 sleep {} ::: 1.1 2.2 3.3 4.4 2>/dev/null; 
  parallel -j2 --resume --joblog /tmp/joblog2 sleep {} ::: 1.1 2.2 3.3 4.4; 
  cat /tmp/joblog2 | wc; 
  rm -f /tmp/joblog2;
echo '### Test --header'; 
  printf "a\tb\n1.2\t3/4.5" | parallel --header echo {b} {a} {b.} {b/} {b//} {b/.}; 
EOF

echo '### Test --shellquote'
cat <<'_EOF' | parallel --shellquote  
awk -v FS="\",\"" '{print $1, $3, $4, $5, $9, $14}' | grep -v "#" | sed -e '1d' -e 's/\"//g' -e 's/\/\/\//\t/g' | cut -f1-6,11 | sed -e 's/\/\//\t/g' -e 's/ /\t/g
_EOF

echo '### Test make .deb package'
cd ~/privat/parallel/packager/debian
stdout make | grep 'To install the GNU Parallel Debian package, run:'
