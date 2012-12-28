#!/bin/bash

SERVER1=parallel-server3
SERVER2=parallel-server2

# -L1 will join lines ending in ' '
cat <<'EOF' | sed -e s/\$SERVER1/$SERVER1/\;s/\$SERVER2/$SERVER2/ | parallel -j10 -k -L1
echo "### Test --delay"
seq 9 | /usr/bin/time -f %e  parallel -j3 --delay 0.57 true {} 2>&1 | 
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

echo "bug #37956: --colsep does not default to '\t' as specified in the man page."
  printf "A\tB\n1\tone" | parallel --header : echo {B} {A}

echo '### Test --tollef'
  parallel -k --tollef echo -- 1 2 3 ::: a b c

echo '### Test --tollef --gnu'
  parallel -k --tollef --gnu echo ::: 1 2 3 -- a b c

echo '### Test --gnu'
  parallel -k --gnu echo ::: 1 2 3 -- a b c

echo '### Test {//}'
  parallel -k echo {//} {} ::: a a/b a/b/c
  parallel -k echo {//} {} ::: /a /a/b /a/b/c
  parallel -k echo {//} {} ::: ./a ./a/b ./a/b/c
  parallel -k echo {//} {} ::: a.jpg a/b.jpg a/b/c.jpg
  parallel -k echo {//} {} ::: /a.jpg /a/b.jpg /a/b/c.jpg
  parallel -k echo {//} {} ::: ./a.jpg ./a/b.jpg ./a/b/c.jpg

echo '### Test {1//}'
  parallel -k echo {1//} {} ::: a a/b a/b/c
  parallel -k echo {1//} {} ::: /a /a/b /a/b/c
  parallel -k echo {1//} {} ::: ./a ./a/b ./a/b/c
  parallel -k echo {1//} {} ::: a.jpg a/b.jpg a/b/c.jpg
  parallel -k echo {1//} {} ::: /a.jpg /a/b.jpg /a/b/c.jpg
  parallel -k echo {1//} {} ::: ./a.jpg ./a/b.jpg ./a/b/c.jpg

echo '### Test --dnr'
  parallel --dnr II -k echo II {} ::: a a/b a/b/c

echo '### Test --dirnamereplace'
  parallel --dirnamereplace II -k echo II {} ::: a a/b a/b/c

echo '### Test https://savannah.gnu.org/bugs/index.php?31716'
  seq 1 5 | stdout parallel -k -l echo {} OK
  seq 1 5 | stdout parallel -k -l 1 echo {} OK

echo '### -k -l -0'
  printf '1\0002\0003\0004\0005\000' | stdout parallel -k -l -0 echo {} OK

echo '### -k -0 -l'
  printf '1\0002\0003\0004\0005\000' | stdout parallel -k -0 -l echo {} OK

echo '### -k -0 -l 1'
  printf '1\0002\0003\0004\0005\000' | stdout parallel -k -0 -l 1 echo {} OK

echo '### -k -0 -l 0'
  printf '1\0002\0003\0004\0005\000' | stdout parallel -k -0 -l 0 echo {} OK

echo '### -k -0 -L -0 - -0 is argument for -L'
  printf '1\0002\0003\0004\0005\000' | stdout parallel -k -0 -L -0 echo {} OK

echo '### -k -0 -L 0 - -L always takes arg'
  printf '1\0002\0003\0004\0005\000' | stdout parallel -k -0 -L 0 echo {} OK

echo '### -k -0 -L 0 - -L always takes arg'
  printf '1\0002\0003\0004\0005\000' | stdout parallel -k -L 0 -0 echo {} OK

echo '### -k -e -0'
  printf '1\0002\0003\0004\0005\000' | stdout parallel -k -e -0 echo {} OK

echo '### -k -0 -e eof'
  printf '1\0002\0003\0004\0005\000' | stdout parallel -k -0 -e eof echo {} OK

echo '### -k -i -0'
  printf '1\0002\0003\0004\0005\000' | stdout parallel -k -i -0 echo {} OK

echo '### -k -0 -i repl'
  printf '1\0002\0003\0004\0005\000' | stdout parallel -k -0 -i repl echo repl OK

EOF
