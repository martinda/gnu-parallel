#!/bin/bash

# Test {.}

# Test weird regexp chars
seq 1 6 | parallel -j1 -I :: -X echo a::b::^c::[.}c | mop

rsync -Ha --delete input-files/testdir2/ tmp/
cd tmp

find . -name '*.jpg' | parallel -j +0 convert -geometry 120 {} {.}_thumb.jpg

find -type f | parallel -k diff {} a/foo ">"{.}.diff
ls | parallel -kvg "ls {}|wc;echo {}"
ls | parallel -kj500 'sleep 1; ls {} | perl -ne "END{print $..\" {}\n\"}"'
ls | parallel -kgj500 'sleep 1; ls {} | perl -ne "END{print $..\" {}\n\"}"'
mkdir 1-col 2-col
ls | parallel -kv touch -- {.}/abc-{.}-{} 2>&1 
ls | parallel -kv rm -- {.}/abc-{.}-{} 2>&1 
#test05.sh:find . -type d -print0 | perl -0 -pe 's:^./::' | parallel -0 -v touch -- {}/abc-{}-{} 2>&1 \
#test05.sh:find . -type d -print0 |  perl -0 -pe 's:^./::' | parallel -0 -v rm -- {}/abc-{}-{} 2>&1 \
#test05.sh:find . -type d -print0 |  perl -0 -pe 's:^./::' | parallel -0 -v rmdir -- {} 2>&1 \
(echo foo;echo bar;echo joe.gif) | parallel -km echo 1{}2{.}3 A{.}B{.}C
(echo foo;echo bar;echo joe.gif) | parallel -kX echo 1{}2{.}3 A{.}B{.}C
seq 1 6 | parallel -kX echo -e '{}.gif\\n' | parallel -km echo a{}b{.}c{.}
seq 1 6 | parallel -kX echo -e '{}.gif\\n' | parallel -kX echo a{}b{.}c{.}
seq 1 60000 | perl -pe 's/$/.gif\n/' | parallel -km echo a{}b{.}c{.} | mop -d 4 "|md5sum" "| wc"
seq 1 60000 | perl -pe 's/$/.gif\n/' | parallel -kX echo a{}b{.}c{.} | mop -d 4 "|md5sum" "| wc"
seq 1 60000 | perl -pe 's/$/.gif\n/' | parallel -kX echo a{}b{.}c{.}{.}{} | wc -l
seq 1 60000 | perl -pe 's/$/.gif\n/' | parallel -kX echo a{}b{.}c{.}{.} | wc -l
seq 1 60000 | perl -pe 's/$/.gif\n/' | parallel -kX echo a{}b{.}c{.} | wc -l
seq 1 60000 | perl -pe 's/$/.gif\n/' | parallel -kX echo a{}b{.}c | wc -l
seq 1 60000 | perl -pe 's/$/.gif\n/' | parallel -kX echo a{}b | wc -l
seq 1 60000 | parallel -I :: -X echo a::b::c:: | wc -l
echo a | parallel -qX echo  "'"{.}"' "
echo a | parallel -qX echo  "'{.}'"
(echo "sleep 3; echo begin"; seq 1 30 | parallel -kq echo "sleep 1; echo {.}"; echo "echo end") \
| parallel -k -j0
seq 1 10 | parallel -k 'seq 1 {.} | parallel -k -I :: echo {.} ::'
seq 1 10 | parallel -k 'seq 1 {.} | parallel -X -k -I :: echo a{.} b::'
seq 1 10 | parallel -k 'seq 1 {.} | parallel -m -k -I :: echo a{.} b::'
(echo a; echo END; echo b) | parallel -k -i -eEND echo repl{.}ce
(echo a; echo END; echo b) | parallel -k --replace -eEND echo repl{.}ce
(echo b; echo c; echo f) | parallel -k -t echo {.}ar 2>&1 >/dev/null
(echo b; echo c; echo f) | parallel -k --verbose echo {.}ar 2>&1 >/dev/null
