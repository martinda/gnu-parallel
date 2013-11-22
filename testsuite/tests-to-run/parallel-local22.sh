#!/bin/bash

cat <<'EOF' | sed -e 's/;$/; /;s/$SERVER1/'$SERVER1'/;s/$SERVER2/'$SERVER2'/' | stdout parallel -k -L1
echo '### Test of xargs -m command lines > 130k'; 
  seq 1 60000 | parallel -m -j1 echo a{}b{}c | tee >(wc >/tmp/awc$$) >(sort | md5sum) >/tmp/a$$; 
  wait; 
  CHAR=$(cat /tmp/a$$ | wc -c); 
  LINES=$(cat /tmp/a$$ | wc -l); 
  echo "Chars per line:" $(echo "$CHAR/$LINES" | bc); 
  cat /tmp/awc$$; 
  rm /tmp/a$$ /tmp/awc$$

echo '### Test of xargs -X command lines > 130k'; 
  seq 1 60000 | parallel -X -j1 echo a{}b{}c | tee >(wc >/tmp/bwc$$) >(sort | (sleep 1; md5sum)) >/tmp/b$$; 
  wait; 
  CHAR=$(cat /tmp/b$$ | wc -c); 
  LINES=$(cat /tmp/b$$ | wc -l); 
  echo "Chars per line:" $(echo "$CHAR/$LINES" | bc); 
  cat /tmp/bwc$$; 
  rm /tmp/b$$ /tmp/bwc$$

echo '### Test of xargs -m command lines > 130k'; 
  seq 1 60000 | parallel -k -j1 -m echo | md5sum

echo '### This causes problems if we kill child processes'; 
  seq 2 40 | parallel -j 0 seq 1 10  | sort | md5sum

echo '### This causes problems if we kill child processes (II)'; 
  seq 1 40 | parallel -j 0 seq 1 10 '| parallel -j 3 echo' | sort | md5sum

echo '### Test -m'; 
  (echo foo;echo bar) | parallel -j1 -m echo 1{}2{}3 A{}B{}C

echo '### Test -X'; 
  (echo foo;echo bar) | parallel -j1 -X echo 1{}2{}3 A{}B{}C

echo '### Bug before 2009-08-26 causing regexp compile error or infinite loop'; 
  echo a | parallel -qX echo  "'"{}"' "

echo '### Bug before 2009-08-26 causing regexp compile error or infinite loop (II)'; 
  echo a | parallel -qX echo  "'{}'"

echo '### nice and tcsh and Bug #33995: Jobs executed with sh instead of $SHELL'; 
  seq 1 2 | SHELL=tcsh MANPATH=. stdout parallel -k --nice 8 setenv a b\;echo \$SHELL

EOF
