#!/bin/bash

SERVER1=parallel-server3
SERVER2=parallel-server2

cat <<'EOF' | sed -e s/\$SERVER1/$SERVER1/\;s/\$SERVER2/$SERVER2/ | parallel -vj0 -k -L1
echo '### Test --return of weirdly named file'
stdout parallel --return {} -vv -S parallel\@$SERVER1 echo '>'{} ::: 'aa<${#}" b' | 
  perl -pe 's/\S*parallel-server\S*/one-server/;s/[a-f0-9]{500,}/hex/;'; rm 'aa<${#}" b'

echo '### Test if remote login shell is csh'
stdout parallel -k -vv -S csh@localhost 'echo $PARALLEL_PID $PARALLEL_SEQ {}| wc -w' ::: a b c | 
  perl -pe 's/\S*parallel-server\S*/one-server/;s/[a-f0-9]{500,}/hex/;'

echo '### Test {} multiple times in different commands'
seq 10 | parallel -v -Xj1 echo {} \; echo {}

echo '### Test of -X {1}-{2} with multiple input sources'
parallel -j1 -kX  echo {1}-{2} ::: a ::: b
parallel -j2 -kX  echo {1}-{2} ::: a b ::: c d
parallel -j2 -kX  echo {1}-{2} ::: a b c ::: d e f
parallel -j0 -kX  echo {1}-{2} ::: a b c ::: d e f

echo '### Test of -X {}-{.} with multiple input sources'
parallel -j1 -kX  echo {}-{.} ::: a ::: b
parallel -j2 -kX  echo {}-{.} ::: a b ::: c d
parallel -j2 -kX  echo {}-{.} ::: a b c ::: d e f
parallel -j0 -kX  echo {}-{.} ::: a b c ::: d e f

echo '### Test of -r with --pipe - the first should give an empty line. The second should not.'
echo | parallel  -j2 -N1 --pipe cat | wc -l
echo | parallel -r -j2 -N1 --pipe cat | wc -l

echo '### Test --tty'
seq 0.1 0.1 0.5 | parallel -j1 --tty tty\;sleep 

EOF
