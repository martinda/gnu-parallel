#!/bin/bash

PAR=parallel

# Test {.}

echo '### Test weird regexp chars'
seq 1 6 | $PAR -j1 -I :: -X echo a::b::^c::[.}c

rsync -Ha --delete input-files/testdir2/ tmp/
cd tmp

echo '### Test {.} and {}'
find . -name '*.jpg' | $PAR -j +0 convert -geometry 120 {} {.}_thumb.jpg

echo '### Test {.} with files that have no . but dir does'
mkdir -p /tmp/test-of-{.}-parallel/subdir
touch /tmp/test-of-{.}-parallel/subdir/file
touch /tmp/test-of-{.}-parallel/subdir/file{.}.funkyextension}}
find /tmp/test-of-{.}-parallel -type f | $PAR echo {.} | sort
rm -rf /tmp/test-of-{.}-parallel/subdir


find -type f | $PAR -k diff {} a/foo ">"{.}.diff
ls | $PAR -kvg "ls {}|wc;echo {}"
ls | $PAR -kj500 'sleep 1; ls {} | perl -ne "END{print $..\" {}\n\"}"'
ls | $PAR -kgj500 'sleep 1; ls {} | perl -ne "END{print $..\" {}\n\"}"'
mkdir 1-col 2-col
ls | $PAR -kv touch -- {.}/abc-{.}-{} 2>&1 
ls | $PAR -kv rm -- {.}/abc-{.}-{} 2>&1 
#test05.sh:find . -type d -print0 | perl -0 -pe 's:^./::' | $PAR -0 -v touch -- {}/abc-{}-{} 2>&1 \
#test05.sh:find . -type d -print0 |  perl -0 -pe 's:^./::' | $PAR -0 -v rm -- {}/abc-{}-{} 2>&1 \
#test05.sh:find . -type d -print0 |  perl -0 -pe 's:^./::' | $PAR -0 -v rmdir -- {} 2>&1 \
echo '### Test -m'
(echo foo;echo bar;echo joe.gif) | $PAR -km echo 1{}2{.}3 A{.}B{.}C
(echo foo;echo bar;echo joe.gif) | $PAR -kX echo 1{}2{.}3 A{.}B{.}C
seq 1 6 | $PAR -k printf '{}.gif\\n' | $PAR -km echo a{}b{.}c{.}
seq 1 6 | $PAR -k printf '{}.gif\\n' | $PAR -kX echo a{}b{.}c{.}
echo '### Test -m with 60000 args'
seq 1 60000 | perl -pe 's/$/.gif\n/' | $PAR -km echo a{}b{.}c{.} | mop -d 4 "|md5sum" "| wc"
echo '### Test -X with 60000 args'
seq 1 60000 | perl -pe 's/$/.gif\n/' | $PAR -kX echo a{}b{.}c{.} | mop -d 4 "|md5sum" "| wc"
echo '### Test -X with 60000 args and 5 expansions'
seq 1 60000 | perl -pe 's/$/.gif\n/' | $PAR -kX echo a{}b{.}c{.}{.}{} | wc -l
seq 1 60000 | perl -pe 's/$/.gif\n/' | $PAR -kX echo a{}b{.}c{.}{.} | wc -l
seq 1 60000 | perl -pe 's/$/.gif\n/' | $PAR -kX echo a{}b{.}c{.} | wc -l
seq 1 60000 | perl -pe 's/$/.gif\n/' | $PAR -kX echo a{}b{.}c | wc -l
seq 1 60000 | perl -pe 's/$/.gif\n/' | $PAR -kX echo a{}b | wc -l

echo '### Test -I with shell meta chars'
seq 1 60000 | $PAR -I :: -X echo a::b::c:: | wc -l
seq 1 60000 | $PAR -I '<>' -X echo 'a<>b<>c<>' | wc -l
seq 1 60000 | $PAR -I '<' -X echo 'a<b<c<' | wc -l
seq 1 60000 | $PAR -I '>' -X echo 'a>b>c>' | wc -l

echo '### Test {.}'
echo a | $PAR -qX echo  "'"{.}"' "
echo a | $PAR -qX echo  "'{.}'"
(echo "sleep 3; echo begin"; seq 1 30 | $PAR -kq echo "sleep 1; echo {.}"; echo "echo end") \
| $PAR -k -j0
echo '### Test -I with -X and -m'
seq 1 10 | $PAR -k 'seq 1 {.} | '$PAR' -k -I :: echo {.} ::'
seq 1 10 | $PAR -k 'seq 1 {.} | '$PAR' -X -k -I :: echo a{.} b::'
seq 1 10 | $PAR -k 'seq 1 {.} | '$PAR' -m -k -I :: echo a{.} b::'
echo '### Test -i'
(echo a; echo END; echo b) | $PAR -k -i -eEND echo repl{.}ce
echo '### Test --replace'
(echo a; echo END; echo b) | $PAR -k --replace -eEND echo repl{.}ce
echo '### Test -t'
(echo b; echo c; echo f) | $PAR -k -t echo {.}ar 2>&1 >/dev/null
echo '### Test --verbose'
(echo b; echo c; echo f) | $PAR -k --verbose echo {.}ar 2>&1 >/dev/null
