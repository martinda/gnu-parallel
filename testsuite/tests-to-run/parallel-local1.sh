#!/bin/bash

cat <<'EOF' | parallel -j0 -k
echo "### Test --basenamereplace"
  parallel -j1 -k -X --basenamereplace FOO echo FOO ::: /a/b.c a/b.c b.c /a/b a/b b
  parallel -k --basenamereplace FOO echo FOO ::: /a/b.c a/b.c b.c /a/b a/b b

echo "### Test --bnr"
  parallel -j1 -k -X --bnr FOO echo FOO ::: /a/b.c a/b.c b.c /a/b a/b b
  parallel -k --bnr FOO echo FOO ::: /a/b.c a/b.c b.c /a/b a/b b

echo "### Test --extensionreplace"
  parallel -j1 -k -X --extensionreplace FOO echo FOO ::: /a/b.c a/b.c b.c /a/b a/b b
  parallel -k --extensionreplace FOO echo FOO ::: /a/b.c a/b.c b.c /a/b a/b b

echo "### Test --er"
  parallel -j1 -k -X --er FOO echo FOO ::: /a/b.c a/b.c b.c /a/b a/b b
  parallel -k --er FOO echo FOO ::: /a/b.c a/b.c b.c /a/b a/b b

echo "### Test --basenameextensionreplace"
  parallel -j1 -k -X --basenameextensionreplace FOO echo FOO ::: /a/b.c a/b.c b.c /a/b a/b b
  parallel -k --basenameextensionreplace FOO echo FOO ::: /a/b.c a/b.c b.c /a/b a/b b

echo "### Test --bner"
  parallel -j1 -k -X --bner FOO echo FOO ::: /a/b.c a/b.c b.c /a/b a/b b
  parallel -k --bner FOO echo FOO ::: /a/b.c a/b.c b.c /a/b a/b b

echo "### Test {/}"
  parallel -j1 -k -X echo {/} ::: /a/b.c a/b.c b.c /a/b a/b b

echo "### Test {/.}"
  parallel -j1 -k -X echo {/.} ::: /a/b.c a/b.c b.c /a/b a/b b

echo "### Test {#/.}"
  parallel -j1 -k -X echo {2/.} ::: /a/number1.c a/number2.c number3.c /a/number4 a/number5 number6

echo "### Test {#/}"
  parallel -j1 -k -X echo {2/} ::: /a/number1.c a/number2.c number3.c /a/number4 a/number5 number6

echo "### Test {#.}"
  parallel -j1 -k -X echo {2.} ::: /a/number1.c a/number2.c number3.c /a/number4 a/number5 number6

echo "### bug #34241: --pipe should not spawn unneeded processes"
  echo | parallel -r -j2 -N1 --pipe md5sum -c && echo OK

echo '### Test of quoting of > bug'
  echo '>/dev/null' | parallel echo

echo '### Test of quoting of > bug if line continuation'
  (echo '> '; echo '> '; echo '>') | parallel --max-lines 3 echo

echo '### Test of --trim illegal'
  stdout parallel --trim fj ::: echo

echo '### Test of eof string on :::'
  parallel -k -E ole echo ::: foo ole bar

echo '### Test of ignore-empty string on :::'
  parallel -k -r echo ::: foo '' ole bar

echo '### Test of trailing space continuation'
  (echo foo; echo '';echo 'ole ';echo bar;echo quux) | xargs -r -L2 echo
  (echo foo; echo '';echo 'ole ';echo bar;echo quux) | parallel -kr -L2 echo
  parallel -kr -L2 echo ::: foo '' 'ole ' bar quux

echo '### Test of trailing space continuation with -E eof'
  (echo foo; echo '';echo 'ole ';echo bar;echo quux) | xargs -r -L2 -E bar echo
  (echo foo; echo '';echo 'ole ';echo bar;echo quux) | parallel -kr -L2 -E bar echo
  parallel -kr -L2 -E bar echo ::: foo '' 'ole ' bar quux

echo '### Test of --colsep'
  echo 'a%c%b' | parallel --colsep % echo {1} {3} {2}
  (echo 'a%c%b'; echo a%c%b%d) | parallel -k --colsep % echo {1} {3} {2} {4}
  (echo a%c%b; echo d%f%e) | parallel -k --colsep % echo {1} {3} {2}
  parallel -k --colsep % echo {1} {3} {2} ::: a%c%b d%f%e
  parallel -k --colsep % echo {1} {3} {2} ::: a%c%b
  parallel -k --colsep % echo {1} {3} {2} {4} ::: a%c%b a%c%b%d

echo '### Test of tab as colsep'
  printf 'def\tabc\njkl\tghi' | parallel -k --colsep '\t' echo {2} {1}
  parallel -k -a <(printf 'def\tabc\njkl\tghi') --colsep '\t' echo {2} {1}

echo '### Test of multiple -a plus colsep'
  parallel --xapply -k -a <(printf 'def\njkl\n') -a <(printf 'abc\tghi\nmno\tpqr') --colsep '\t' echo {2} {1}

echo '### Test of multiple -a no colsep'
  parallel --xapply -k -a <(printf 'ghi\npqr\n') -a <(printf 'abc\tdef\njkl\tmno') echo {2} {1}

echo '### Test of quoting after colsplit'
  parallel --colsep % echo {2} {1} ::: '>/dev/null%>/tmp/null'

echo '### Test of --colsep as regexp'
  (echo 'a%c%%b'; echo a%c%b%d) | parallel -k --colsep %+ echo {1} {3} {2} {4}
  parallel -k --colsep %+ echo {1} {3} {2} {4} ::: a%c%%b a%c%b%d
  (echo 'a% c %%b'; echo a%c% b %d) | parallel -k --colsep %+ echo {1} {3} {2} {4}
  (echo 'a% c %%b'; echo a%c% b %d) | parallel -k --colsep %+ echo '"{1}_{3}_{2}_{4}"'

echo '### Test of -C'
  (echo 'a% c %%b'; echo a%c% b %d) | parallel -k -C %+ echo '"{1}_{3}_{2}_{4}"'

echo '### Test of --trim n'
  (echo 'a% c %%b'; echo a%c% b %d) | parallel -k --trim n --colsep %+ echo '"{1}_{3}_{2}_{4}"'
  parallel -k -C %+ echo '"{1}_{3}_{2}_{4}"' ::: 'a% c %%b' 'a%c% b %d'

echo '### Test of bug: If input is empty string'
  (echo ; echo abcbdbebf;echo abc) | parallel -k --colsep b -v echo {1}{2}

echo '### Test bug #34241: --pipe should not spawn unneeded processes'
  seq 3 | parallel -j30 --pipe --block-size 10 cat\;echo o 

echo '### Test :::: mixed with :::'
echo '### Test :::: < ::: :::'
  parallel -k echo {1} {2} {3} :::: <(seq 6 7) ::: 4 5 ::: 1 2 3

echo '### Test :::: <  < :::: <'
  parallel -k echo {1} {2} {3} :::: <(seq 6 7) <(seq 4 5) :::: <(seq 1 3)

echo '### Test -a ::::  < :::: <'
  parallel -k -a <(seq 6 7) echo {1} {2} {3} :::: <(seq 4 5) :::: <(seq 1 3)

echo '### Test -a -a :::'
  parallel -k -a <(seq 6 7) -a <(seq 4 5) echo {1} {2} {3} ::: 1 2 3

echo '### Test -a - -a :::'
  seq 6 7 | parallel -k -a - -a <(seq 4 5) echo {1} {2} {3} ::: 1 2 3

echo '### Test :::: < - :::'
  seq 4 5 | parallel -k echo {1} {2} {3} :::: <(seq 6 7) - ::: 1 2 3

echo '### Test -E'
  seq 1 100 | parallel -k -E 5 echo :::: - ::: 2 3 4 5 6 7 8 9 10 :::: <(seq 3 11)

echo '### Test -E one empty'
  seq 1 100 | parallel -k -E 3 echo :::: - ::: 2 3 4 5 6 7 8 9 10 :::: <(seq 3 11)

echo '### Test -E 2 empty'
  seq 1 100 | parallel -k -E 3 echo :::: - ::: 3 4 5 6 7 8 9 10 :::: <(seq 3 11)

echo '### Test -E all empty'
  seq 3 100 | parallel -k -E 3 echo :::: - ::: 3 4 5 6 7 8 9 10 :::: <(seq 3 11)

echo '### Test {#}'
  seq 1 10 | parallel -k echo {#}

echo '### Test --seqreplace and line too long'
  seq 1 100 | stdout parallel -k --seqreplace I echo $(perl -e 'print "I"x130000') \|wc | uniq

echo '### bug #37042: -J foo is taken from the whole command line - not just the part before the command'
  echo '--tagstring foo' > ~/.parallel/bug_37042_profile; 
  parallel -J bug_37042_profile echo ::: tag_with_foo; 
  parallel --tagstring a -J bug_37042_profile echo ::: tag_with_a; 
  parallel --tagstring a echo -J bug_37042_profile ::: print_-J_bug_37042_profile;

echo '### Bug introduce by fixing bug #37042'
  parallel --xapply -a <(printf 'abc') --colsep '\t' echo {1}

echo "### Test --header with -N"
  (echo h1; echo h2; echo 1a;echo 1b; echo 2a;echo 2b; echo 3a)| parallel -j1 --pipe -N2 -k --header '.*\n.*\n' echo Start\;cat \; echo Stop

echo "### Test --header with --block 1k"
  (echo h1; echo h2; perl -e '$a="x"x110;for(1..22){print $_,$a,"\n"'})| parallel -j1 --pipe -k --block 1k --header '.*\n.*\n' echo Start\;cat \; echo Stop

echo "### Test --header with multiple :::"
  parallel --header : echo {a} {b} {1} {2} ::: b b1 ::: a a2


EOF
