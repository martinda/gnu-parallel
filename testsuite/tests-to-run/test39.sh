#!/bin/bash


# Tests that failed for OO-rewrite

parallel -u --semaphore seq 1 10 '|' pv -qL 20
sem --wait; echo done


echo a | parallel echo {1}

echo "echo a" | parallel

parallel -j1 -I :: -X echo 'a::b::^c::[.}c' ::: 1

echo "### BUG: The length for -X is not close to max (131072)"
seq 1 4000 | parallel -X echo {.} aa {}{.} {}{}d{} {}dd{}d{.} |head -n 1 |wc

echo "### BUG: empty lines with --show-limit"
echo | parallel  --show-limits

echo '### Test -N'
seq 1 5 | parallel -kN3 echo {1} {2} {3}

echo '### Test --arg-file-sep with files of different lengths'
parallel  --arg-file-sep :::: -k echo {1} {2} :::: <(seq 1 1) <(seq 3 4)

echo '### Test respect -s'
parallel -kvm -IARG -s15 echo ARG ::: 1 22 333 4444 55555 666666 7777777 88888888 999999999

echo '### Test eof string after :::'
parallel -k -E ole echo ::: foo ole bar

echo '### Test -C and --trim rl'
parallel -k -C %+ echo '"{1}_{3}_{2}_{4}"' ::: 'a% c %%b' 'a%c% b %d'

echo '### Test empty input'
</dev/null parallel -j +0 echo

echo '### Test -m'
seq 1 2 | parallel -m echo

echo '### Test :::'
parallel echo ::: 1

echo '### Test context_replace'
echo a | parallel -qX echo  "'"{}"' "

echo '### Test -N2 {2}'
seq 1 4 | parallel -kN2 echo arg1:{1} seq:'$'PARALLEL_SEQ arg2:{2}

echo '### Test -E (should only output foo ole)'
(echo foo; echo '';echo 'ole ';echo bar;echo quux) | parallel -kr -L2 -E bar echo
parallel -kr -L2 -E bar echo ::: foo '' 'ole ' bar quux

echo '### Test -r (should only output foo ole bar\nquux)'
parallel -kr -L2 echo ::: foo '' 'ole ' bar quux

echo '### Test of tab as colsep'
printf 'def\tabc\njkl\tghi' | parallel -k --colsep '\t' echo {2} {1}
parallel -k -a <(printf 'def\tabc\njkl\tghi') --colsep '\t' echo {2} {1}

