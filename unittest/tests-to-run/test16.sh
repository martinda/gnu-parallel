#!/bin/bash

PAR=parallel

# Test {.}

# Test weird regexp chars
seq 1 6 | $PAR -j1 -I :: -X echo a::b::^c::[.}c | mop

rsync -Ha --delete input-files/testdir2/ tmp/
cd tmp

find . -name '*.jpg' | $PAR -j +0 convert -geometry 120 {} {.}_thumb.jpg

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
(echo foo;echo bar;echo joe.gif) | $PAR -km echo 1{}2{.}3 A{.}B{.}C
(echo foo;echo bar;echo joe.gif) | $PAR -kX echo 1{}2{.}3 A{.}B{.}C
seq 1 6 | $PAR -kX echo -e '{}.gif\\n' | $PAR -km echo a{}b{.}c{.}
seq 1 6 | $PAR -kX echo -e '{}.gif\\n' | $PAR -kX echo a{}b{.}c{.}
seq 1 60000 | perl -pe 's/$/.gif\n/' | $PAR -km echo a{}b{.}c{.} | mop -d 4 "|md5sum" "| wc"
seq 1 60000 | perl -pe 's/$/.gif\n/' | $PAR -kX echo a{}b{.}c{.} | mop -d 4 "|md5sum" "| wc"
seq 1 60000 | perl -pe 's/$/.gif\n/' | $PAR -kX echo a{}b{.}c{.}{.}{} | wc -l
seq 1 60000 | perl -pe 's/$/.gif\n/' | $PAR -kX echo a{}b{.}c{.}{.} | wc -l
seq 1 60000 | perl -pe 's/$/.gif\n/' | $PAR -kX echo a{}b{.}c{.} | wc -l
seq 1 60000 | perl -pe 's/$/.gif\n/' | $PAR -kX echo a{}b{.}c | wc -l
seq 1 60000 | perl -pe 's/$/.gif\n/' | $PAR -kX echo a{}b | wc -l
seq 1 60000 | $PAR -I :: -X echo a::b::c:: | wc -l
seq 1 60000 | $PAR -I '<>' -X echo 'a<>b<>c<>' | wc -l
seq 1 60000 | $PAR -I '<' -X echo 'a<b<c<' | wc -l
seq 1 60000 | $PAR -I '>' -X echo 'a>b>c>' | wc -l
echo a | $PAR -qX echo  "'"{.}"' "
echo a | $PAR -qX echo  "'{.}'"
(echo "sleep 3; echo begin"; seq 1 30 | $PAR -kq echo "sleep 1; echo {.}"; echo "echo end") \
| $PAR -k -j0
seq 1 10 | $PAR -k 'seq 1 {.} | '$PAR' -k -I :: echo {.} ::'
seq 1 10 | $PAR -k 'seq 1 {.} | '$PAR' -X -k -I :: echo a{.} b::'
seq 1 10 | $PAR -k 'seq 1 {.} | '$PAR' -m -k -I :: echo a{.} b::'
(echo a; echo END; echo b) | $PAR -k -i -eEND echo repl{.}ce
(echo a; echo END; echo b) | $PAR -k --replace -eEND echo repl{.}ce
(echo b; echo c; echo f) | $PAR -k -t echo {.}ar 2>&1 >/dev/null
(echo b; echo c; echo f) | $PAR -k --verbose echo {.}ar 2>&1 >/dev/null
