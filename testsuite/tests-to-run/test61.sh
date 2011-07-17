#!/bin/bash

SERVER1=parallel-server3
SERVER2=parallel-server2

cat <<'EOF' | sed -e s/\$SERVER1/$SERVER1/\;s/\$SERVER2/$SERVER2/ | parallel -j0 -k
echo '### Test --return of weirdly named file'
stdout parallel --return {} -vv -S $SERVER1 echo '>'{} ::: 'aa<${#}" b'; rm 'aa<${#}" b'

echo '### Test if remote login shell is csh'
stdout parallel -vv -S csh@localhost 'echo $PARALLEL_PID $PARALLEL_SEQ {}| wc -w' ::: a b c

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
EOF
