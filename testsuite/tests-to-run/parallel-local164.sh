#!/bin/bash

SERVER1=parallel-server3
SERVER2=parallel-server2

# -L1 will join lines ending in ' '
cat <<'EOF' | sed -e s/\$SERVER1/$SERVER1/\;s/\$SERVER2/$SERVER2/ | parallel -j10 -k -L1
echo "### Test --delay"
seq 9 | /usr/bin/time -f %e  parallel -j3 --delay 0.53 true {} 2>&1 | 
  perl -ne '$_ > 5 and print "More than 5 secs: OK\n"'

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

echo "### Computing length of command line"
seq 1 2 | parallel -k -N2 echo {1} {2}
parallel --xapply -k -a <(seq 11 12) -a <(seq 1 3) echo
parallel -k -C %+ echo '"{1}_{3}_{2}_{4}"' ::: 'a% c %%b' 'a%c% b %d'
parallel -k -C %+ echo {4} ::: 'a% c %%b'

echo "### test08"; 
  cd input-files/test08; 
  ls | parallel -q  perl -ne '/_PRE (\d+)/ and $p=$1; /hatchname> (\d+)/ and $1!=$p and print $ARGV,"\n"' | sort;

seq 1 10 | parallel -j 1 echo | sort
seq 1 10 | parallel -j 2 echo | sort
seq 1 10 | parallel -j 3 echo | sort

echo "bug #37694: Empty string argument skipped when using --quote"
parallel -q --nonall perl -le 'print scalar @ARGV' 'a' 'b' ''

EOF
