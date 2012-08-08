#!/bin/bash

PAR="nice nice parallel -j2 --pipe --keeporder --block 150000 --tmpdir=/dev/shm"
export PAR
XAP="nice nice parallel --xapply"
export XAP

cat <<'EOF' | sed -e 's/$SERVER1/'$SERVER1'/;s/$SERVER2/'$SERVER2'/' | stdout parallel -j0 -k -L1
echo '### Test --spreadstdin - more procs than args'; 
  rm -f /tmp/parallel.ss.*; 
  seq 1 5 | stdout parallel -j 10 --spreadstdin 'cat >/tmp/parallel.ss.$PARALLEL_SEQ' >/dev/null; 
  cat /tmp/parallel.ss.*;

echo '### Test --spreadstdin - more args than procs'; 
  rm /tmp/parallel.ss2.*; 
  seq 1 10 | stdout parallel -j 5 --spreadstdin 'cat >/tmp/parallel.ss2.$PARALLEL_SEQ' >/dev/null; 
  cat /tmp/parallel.ss2.*

nice nice seq 1 1000 | nice nice parallel -j1 --spreadstdin cat "|cat "|wc -c
nice nice seq 1 10000 | nice nice parallel -j10 --spreadstdin cat "|cat "|wc -c
nice nice seq 1 100000 | nice nice parallel -j1 --spreadstdin cat "|cat "|wc -c
nice nice seq 1 1000000 | nice nice parallel -j10 --spreadstdin cat "|cat "|wc -c

seq 1 10 | parallel --recend "\n" -j1 --spreadstdin gzip -9 >/tmp/foo.gz

echo '### Test --spreadstdin - similar to the failing below'; 
  nice seq 1 100000 | nice nice parallel --recend "\n" -j10 --spreadstdin gzip -9 >/tmp/foo2.gz; 
  diff <(nice seq 1 100000) <(zcat /tmp/foo2.gz |sort -n); 
  diff <(nice seq 1 100000|wc -c) <(zcat /tmp/foo2.gz |wc -c)

echo '### Test --spreadstdin - this failed during devel'; 
  nice seq 1 1000000 | md5sum; 
  nice seq 1 1000000 | nice nice parallel --recend "\n" -j10 --spreadstdin gzip -9 | zcat | sort -n | md5sum

echo '### Test --spreadstdin -k'; 
  nice seq 1 1000000 | nice nice parallel -k --recend "\n" -j10 --spreadstdin gzip -9 | zcat | md5sum

echo '### Test --spreadstdin --files'; 
  nice seq 1 1000000 | shuf | parallel --files --recend "\n" -j10 --spreadstdin sort -n | parallel -Xj1 sort -nm {} ";"rm {} | md5sum

echo '### Test --number-of-cpus'; 
  parallel --number-of-cpus

echo '### Test --number-of-cores'; 
  parallel --number-of-cores

echo '### Test --use-cpus-instead-of-cores'; 
  (seq 1 4 | stdout parallel --use-cpus-instead-of-cores -j100% sleep) && echo CPUs done & 
  (seq 1 4 | stdout parallel -j100% sleep) && echo cores done & 
  echo 'Cores should complete first on machines with less than 4 physical CPUs'; 
  wait

echo '### Test --tag ::: a ::: b'; 
  stdout parallel -k --tag -j1  echo stderr-{.} ">&2;" echo stdout-{} ::: a ::: b

echo '### Test --tag ::: a b'; 
  stdout parallel -k --tag -j1  echo stderr-{.} ">&2;" echo stdout-{} ::: a b

echo '### Test --tag -X ::: a b'; 
  stdout parallel -k --tag -X -j1  echo stderr-{.} ">&2;" echo stdout-{} ::: a b

echo '### Test bash redirection <()';
  parallel 'cat <(echo {}); echo b' ::: a

echo '### Test bug https://savannah.gnu.org/bugs/index.php?33352'

# produce input slowly to parallel so that it will reap a process
# while blocking in read()

# Having found the solution it is suddenly very easy to reproduce the
# problem - even on other hardware:
#
# perl -e '@x=1 .. 17000; for(1..30) { print "@x\n"}' | pv -qL 200000
# |parallel -j2 --pipe --keeporder --block 150000 cat | md5sum
#
# This gives different md5sums for each run.
#
# The problem is that read(STDIN) is being interrupted by a dead
# child. The chance of this happening is very small if there are few
# children dying or read(STDIN) never has to wait for data.
#
# The test above forces data to arrive slowly (using pv) which causes
# read(STDIN) to take a long time - thus being interrupted by a dead
# child.

perl -e '@x=1 .. 17000; for(1..100) { print "@x\n"}' | md5sum
nice nice perl -e '@x=1 .. 17000; for(1..100) { print "@x\n"}' | pv -qL 1000000 | 
  $PAR cat | md5sum
nice nice perl -e '@x=1 .. 17000; for(1..100) { print "@x\n"}' | pv -qL 1000000 | 
  $PAR --recend '' cat | md5sum
nice nice perl -e '@x=1 .. 17000; for(1..100) { print "@x\n"}' | pv -qL 1000000 | 
  $PAR --recend '' --files cat | parallel -Xj1 cat {} ';' rm {} | md5sum
nice nice perl -e '@x=1 .. 17000; for(1..100) { print "@x\n"}' | pv -qL 1000000 | 
  $PAR --recend '' --files cat | parallel -Xj1 cat {} ';' rm {} | md5sum
nice nice perl -e '@x=1 .. 17000; for(1..100) { print "@x\n"}' | pv -qL 1000000 | 
  $PAR --recend '' --files --tmpdir /dev/shm cat | parallel -Xj1 cat {} ';' rm {} | md5sum
nice nice perl -e '@x=1 .. 17000; for(1..100) { print "@x\n"}' | pv -qL 1000000 | 
  $PAR --recend '' --files --halt-on-error 2 cat | parallel -Xj1 cat {} ';' rm {} | md5sum

echo '### Test of -j filename - non-existent file'; 
  nice stdout parallel -j no_such_file echo ::: 1

echo '### Test of -j filename'; 
  echo 3 >/tmp/jobs_to_run1; 
  parallel -j /tmp/jobs_to_run1 -v sleep {} ::: 10 8 6 5 4; 
  # Should give 6 8 10 5 4

echo '### Test ::::'
echo '### Change --arg-file-sep'
$XAP --arg-file-sep :::: -k echo {1} {2} :::: <(seq 1 10) <(seq 5 15)
$XAP --arg-file-sep .--- -k echo {1} {2} .--- <(seq 1 10) <(seq 5 15)
$XAP --argfilesep :::: -k echo {1} {2} :::: <(seq 1 10) <(seq 5 15)
$XAP --argfilesep .--- -k echo {1} {2} .--- <(seq 1 10) <(seq 5 15)

echo '### Test xapply --max-replace-args'
seq 0 7 | $XAP -k --max-replace-args=3 echo {3} {2} {1}
echo '### Test -N'
seq 1 5 | $XAP -kN3 echo {1} {2} {3}
echo '### Test -N with 0'
seq 0 7 | $XAP -kN3 echo {1} {2} {3}
echo '### Test :::: on nonexistent'
stdout $XAP -k echo {1} {2} {3} :::: nonexistent
echo '### Test :::: two files'
$XAP -k echo {1} {2} :::: <(seq 1 10) <(seq 5 15)
echo '### Test -d, ::::'
$XAP -kd, 'echo a{1} {2}b' :::: <(echo 1,2,3,) <(echo 5,6,7,8)
echo '### Test -d, :::: one file too much'
$XAP -kd, echo 'a{1}' '{2}b' :::: <(echo 1,2,3,) <(echo 5,6,7,8) <(echo 9,0)
echo '### Bug: did not quote'
$XAP echo {1} {2} :::: <(echo '>') <(echo b)
echo '### Quote test triplet 1'
$XAP -kv :::: <(echo 'echo a'; echo 'echo b')
$XAP -kv -a <(echo 'echo a'; echo 'echo b')
(echo 'echo a'; echo 'echo b') | $XAP -kv
echo '### Quote test triplet 2'
$XAP -kv echo :::: <(echo 'echo a'; echo 'echo b')
$XAP -kv -a <(echo 'echo a'; echo 'echo b') echo
(echo 'echo a'; echo 'echo b') | $XAP -kv echo
echo '### Quoting if there is a command and 2 arg files'
$XAP -kv echo :::: <(echo 'echo a') <(echo 'echo b')
echo '### Quoting if there is a command and 2 arg files of uneven length'
$XAP -kv echo :::: <(echo 'echo a';echo a1) <(echo 'echo b')
echo '### Quoting if there is no command and 2 arg files'
$XAP -kv :::: <(echo 'echo a') <(echo 'echo b')
echo '### Quoting if there is no command and 2 arg files of uneven length'
$XAP -kv :::: <(echo 'echo a';echo echo a1) <(echo 'echo b')

echo '### Test multiple -a'
$XAP -kv -a <(echo a) -a <(echo b) echo {2} {1}
$XAP -kv echo {2} {1} :::: <(echo a) <(echo b)
echo '### Multiple -a: An unused file'
$XAP -kv -a <(echo a) -a <(echo b) -a <(echo c) echo {2} {1}
$XAP -kv echo {2} {1} :::: <(echo a) <(echo b) <(echo c)
echo '### Multiple -a: nonexistent'
stdout $XAP -kv echo {2} {1} :::: nonexist nonexist2
stdout $XAP -kv -a nonexist -a nonexist2 echo {2} {1}

echo '### Test {#.}'
$XAP -kv -a <(echo a-noext) -a <(echo b-withext.extension) -a <(echo c-ext.gif) echo {3.} {2.} {1.}

echo "### Tests that failed for OO-rewrite"
parallel -u --semaphore seq 1 10 '|' pv -qL 20; sem --wait; echo done
echo a | parallel echo {1}
echo "echo a" | parallel
parallel -j1 -I :: -X echo 'a::b::^c::[.}c' ::: 1

echo "### BUG: The length for -X is not close to max (131072)"
seq 1 4000 | parallel -k -X echo {.} aa {}{.} {}{}d{} {}dd{}d{.} |head -n 1 |wc

echo "### BUG: empty lines with --show-limit"
echo | parallel  --show-limits

echo '### Test -N'
seq 1 5 | parallel -kN3 echo {1} {2} {3}

echo '### Test --arg-file-sep with files of different lengths'
parallel --xapply --arg-file-sep :::: -k echo {1} {2} :::: <(seq 1 1) <(seq 3 4)

echo '### Test respect -s'
parallel -kvm -IARG -s15 echo ARG ::: 1 22 333 4444 55555 666666 7777777 88888888 999999999

echo '### Test eof string after :::'
parallel -k -E ole echo ::: foo ole bar

echo '### Test -C and --trim rl'
parallel -k -C %+ echo '"{1}_{3}_{2}_{4}"' ::: 'a% c %%b' 'a%c% b %d'

echo '### Test empty input'
</dev/null parallel -j +0 echo

echo '### Test -m'
seq 1 2 | parallel -k -m echo

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

EOF

echo '### Test of -j filename with file content changing'; 
  echo 1 >/tmp/jobs_to_run2; 
  (sleep 3; echo 10 >/tmp/jobs_to_run2) &
  parallel -j /tmp/jobs_to_run2 -v sleep {} ::: 3.3 1.21 1.43 1.54 1.32 1 1 1 1 1 1 1 1 1 1 1
