#!/bin/bash

# Test {.}

rsync -Ha --delete input-files/testdir2/ tmp/
cd tmp

echo '### Test {.} and {}'
find . -name '*.jpg' | parallel -j +0 convert -geometry 120 {} {.}_thumb.jpg

echo '### Test {.} with files that have no . but dir does'
mkdir -p /tmp/test-of-{.}-parallel/subdir
touch /tmp/test-of-{.}-parallel/subdir/file
touch /tmp/test-of-{.}-parallel/subdir/file{.}.funkyextension}}
find /tmp/test-of-{.}-parallel -type f | parallel echo {.} | sort
rm -rf /tmp/test-of-{.}-parallel/subdir


find -type f | parallel -k diff {} a/foo ">"{.}.diff
ls | parallel -kv --group "ls {}|wc;echo {}"
ls | parallel -kj500 'sleep 1; ls {} | perl -ne "END{print $..\" {}\n\"}"'
ls | parallel -kj500 --group 'sleep 1; ls {} | perl -ne "END{print $..\" {}\n\"}"'
mkdir 1-col 2-col
ls | parallel -kv touch -- {.}/abc-{.}-{} 2>&1
ls | parallel -kv rm -- {.}/abc-{.}-{} 2>&1
#test05.sh:find . -type d -print0 | perl -0 -pe 's:^./::' | parallel -0 -v touch -- {}/abc-{}-{} 2>&1 \
#test05.sh:find . -type d -print0 |  perl -0 -pe 's:^./::' | parallel -0 -v rm -- {}/abc-{}-{} 2>&1 \
#test05.sh:find . -type d -print0 |  perl -0 -pe 's:^./::' | parallel -0 -v rmdir -- {} 2>&1 \

# -L1 will join lines ending in ' '
cat <<'EOF' | sed -e s/\$SERVER1/$SERVER1/\;s/\$SERVER2/$SERVER2/ | nice parallel -j0 -k -L1
echo '### Test compress'
  seq 5 | parallel -j2 --tag --compress 'seq {} | pv -q -L 10'

echo '### Test compress - stderr'
  seq 5 | parallel -j2 --tag --compress 'seq {} | pv -q -L 10 >&2' 2>&1 >/dev/null

echo '### Test weird regexp chars'
  seq 1 6 | parallel -j1 -I :: -X echo a::b::^c::[.}c

echo '### Test -m'
(echo foo;echo bar;echo joe.gif) | parallel -j1 -km echo 1{}2{.}3 A{.}B{.}C
(echo foo;echo bar;echo joe.gif) | parallel -j1 -kX echo 1{}2{.}3 A{.}B{.}C
seq 1 6 | parallel -k printf '{}.gif\\n' | parallel -j1 -km echo a{}b{.}c{.}
seq 1 6 | parallel -k printf '{}.gif\\n' | parallel -j1 -kX echo a{}b{.}c{.}

echo '### Test -m with 60000 args'; 
  seq 1 60000 | perl -pe 's/$/.gif\n/' | 
  parallel -j1 -km echo a{}b{.}c{.} | 
  tee >(wc) >(md5sum) >/dev/null; 
  wait

echo '### Test -X with 60000 args'; 
  seq 1 60000 | perl -pe 's/$/.gif\n/' | 
  parallel -j1 -kX echo a{}b{.}c{.} | 
  tee >(wc) >(md5sum) >/dev/null; 
  wait

echo '### Test -X with 60000 args and 5 expansions'
seq 1 60000 | perl -pe 's/$/.gif\n/' | parallel -j1 -kX echo a{}b{.}c{.}{.}{} | wc -l
seq 1 60000 | perl -pe 's/$/.gif\n/' | parallel -j1 -kX echo a{}b{.}c{.}{.} | wc -l
seq 1 60000 | perl -pe 's/$/.gif\n/' | parallel -j1 -kX echo a{}b{.}c{.} | wc -l
seq 1 60000 | perl -pe 's/$/.gif\n/' | parallel -j1 -kX echo a{}b{.}c | wc -l
seq 1 60000 | perl -pe 's/$/.gif\n/' | parallel -j1 -kX echo a{}b | wc -l
echo '### Test {.} does not repeat more than {}'
seq 1 15 | perl -pe 's/$/.gif\n/' | parallel -j1 -s 80 -kX echo a{}b{.}c{.}
seq 1 15 | perl -pe 's/$/.gif\n/' | parallel -j1 -s 80 -km echo a{}b{.}c{.}
seq 1 15 | perl -pe 's/$/.gif/'   | parallel -j1 -s 80 -kX echo a{}b{.}c{.}
seq 1 15 | perl -pe 's/$/.gif/'   | parallel -j1 -s 80 -km echo a{}b{.}c{.}

echo '### Test -I with shell meta chars'
seq 1 60000 | parallel -j1 -I :: -X echo a::b::c:: | wc -l
seq 1 60000 | parallel -j1 -I '<>' -X echo 'a<>b<>c<>' | wc -l
seq 1 60000 | parallel -j1 -I '<' -X echo 'a<b<c<' | wc -l
seq 1 60000 | parallel -j1 -I '>' -X echo 'a>b>c>' | wc -l

echo '### Test {.}'
echo a | parallel -qX echo  "'"{.}"' "
echo a | parallel -qX echo  "'{.}'"
(echo "sleep 3; echo begin"; seq 1 30 | parallel -kq echo "sleep 1; echo {.}"; echo "echo end") | parallel -k -j0
echo '### Test -I with -X and -m'
seq 1 10 | parallel -k 'seq 1 {.} | 'parallel' -k -I :: echo {.} ::'
seq 1 10 | parallel -k 'seq 1 {.} | 'parallel' -j1 -X -k -I :: echo a{.} b::'
seq 1 10 | parallel -k 'seq 1 {.} | 'parallel' -j1 -m -k -I :: echo a{.} b::'
echo '### Test -i'
(echo a; echo END; echo b) | parallel -k -i -eEND echo repl{.}ce
echo '### Test --replace'
(echo a; echo END; echo b) | parallel -k --replace -eEND echo repl{.}ce
echo '### Test -t'
(echo b; echo c; echo f) | parallel -k -t echo {.}ar 2>&1 >/dev/null
echo '### Test --verbose'
(echo b; echo c; echo f) | parallel -k --verbose echo {.}ar 2>&1 >/dev/null
EOF
