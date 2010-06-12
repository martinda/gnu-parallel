#!/bin/bash

# Test xargs compatibility

PAR=parallel

echo '### Test -L -l and --max-lines'
(echo a_b;echo c) | parallel -km -L2  echo
(echo a_b;echo c) | xargs -L2  echo
(echo a_b;echo c) | parallel -km -L1  echo
(echo a_b;echo c) | xargs -L1  echo
(echo a_b' ';echo c;echo d) | parallel -km -L1  echo
(echo a_b' ';echo c;echo d) | xargs -L1  echo
(echo a_b' ';echo c;echo d;echo e) | parallel -km -L2 echo
(echo a_b' ';echo c;echo d;echo e) | xargs -L2 echo
(echo a_b' ';echo c;echo d;echo e) | parallel -km -l echo
(echo a_b' ';echo c;echo d;echo e) | xargs -l echo
(echo a_b' ';echo c;echo d;echo e) | parallel -km -l2 echo
(echo a_b' ';echo c;echo d;echo e) | xargs -l2 echo
(echo a_b' ';echo c;echo d;echo e) | parallel -km -l1 echo
(echo a_b' ';echo c;echo d;echo e) | xargs -l1 echo
(echo a_b' ';echo c;echo d;echo e) | parallel -km --max-lines 2 echo
(echo a_b' ';echo c;echo d;echo e) | xargs --max-lines=2 echo
(echo a_b' ';echo c;echo d;echo e) | parallel -km --max-lines echo
(echo a_b' ';echo c;echo d;echo e) | xargs --max-lines echo

echo '### test too long args'
perl -e 'print "z"x1000000' | parallel echo 2>&1
perl -e 'print "z"x1000000' | xargs echo 2>&1
(seq 1 10; perl -e 'print "z"x1000000'; seq 12 15) | stdout parallel -j1 -km -s 10 echo
(seq 1 10; perl -e 'print "z"x1000000'; seq 12 15) | stdout xargs -s 10 echo
echo '### Test -x'
(seq 1 10; echo 12345; seq 12 15) | stdout parallel -j1 -km -s 10 -x echo
(seq 1 10; echo 12345; seq 12 15) | stdout xargs -s 10 -x echo
(seq 1 10; echo 1234; seq 12 15) | stdout parallel -j1 -km -s 10 -x echo
(seq 1 10; echo 1234; seq 12 15) | stdout xargs -s 10 -x echo
echo '### Test bugfix if no command given'
(echo echo; seq 1 5; perl -e 'print "z"x1000000'; seq 12 15) | stdout parallel -j1 -km -s 10



echo '### Test -a and --arg-file: Read input from file instead of stdin'
seq 1 10 >/tmp/$$
$PAR -k -a /tmp/$$ echo
$PAR -k --arg-file /tmp/$$ echo

cd input-files/test15

echo 'xargs Expect: 3 1 2'
echo 3 | xargs -P 1 -n 1 -a files cat -
echo 'parallel Expect: 3 1 2'
echo 3 | parallel -k -P 2 -n 1 -a files cat -
echo 'xargs Expect: 1 3 2'
echo 3 | xargs -I {} -P 1 -n 1 -a files cat {} -
echo 'parallel Expect: 1 3 2'
echo 3 | parallel -k -I {} -P 1 -n 1 -a files cat {} -

echo '### Test -i and --replace: Replace with argument'
(echo a; echo END; echo b) | $PAR -k -i -eEND echo repl{}ce
(echo a; echo END; echo b) | $PAR -k --replace -eEND echo repl{}ce
(echo a; echo END; echo b) | $PAR -k -i+ -eEND echo repl+ce
(echo e; echo END; echo b) | $PAR -k -i'*' -eEND echo r'*'plac'*'
(echo a; echo END; echo b) | $PAR -k --replace + -eEND echo repl+ce
(echo a; echo END; echo b) | $PAR -k --replace== -eEND echo repl=ce
(echo a; echo END; echo b) | $PAR -k --replace = -eEND echo repl=ce
(echo a; echo END; echo b) | $PAR -k --replace=^ -eEND echo repl^ce
(echo a; echo END; echo b) | $PAR -k -I^ -eEND echo repl^ce

echo '### Test -E: Artificial end-of-file'
(echo include this; echo END; echo not this) | $PAR -k -E END echo
(echo include this; echo END; echo not this) | $PAR -k -EEND echo

echo '### Test -e and --eof: Artificial end-of-file'
(echo include this; echo END; echo not this) | $PAR -k -e END echo
(echo include this; echo END; echo not this) | $PAR -k -eEND echo
(echo include this; echo END; echo not this) | $PAR -k --eof=END echo
(echo include this; echo END; echo not this) | $PAR -k --eof END echo

echo '### Test -n and --max-args: Max number of args per line (only with -X and -m)'
(echo line 1;echo line 2;echo line 3) | $PAR -k -n1 -m echo
(echo line 1;echo line 1;echo line 2) | $PAR -k -n2 -m echo
(echo line 1;echo line 2;echo line 3) | $PAR -k -n1 -X echo
(echo line 1;echo line 1;echo line 2) | $PAR -k -n2 -X echo
(echo line 1;echo line 2;echo line 3) | $PAR -k --max-args=1 -X echo
(echo line 1;echo line 2;echo line 3) | $PAR -k --max-args 1 -X echo
(echo line 1;echo line 1;echo line 2) | $PAR -k --max-args=2 -X echo
(echo line 1;echo line 1;echo line 2) | $PAR -k --max-args 2 -X echo

echo '### Test --max-procs and -P: Number of processes'
seq 1 10 | $PAR -k --max-procs +0 echo max proc
seq 1 10 | $PAR -k -P 200% echo 200% proc

echo '### Test --delimiter and -d: Delimiter instead of newline'
echo '# Yes there is supposed to be an extra newline for -d N'
echo line 1Nline 2Nline 3 | $PAR -k -d N echo This is
echo line 1Nline 2Nline 3 | $PAR -k --delimiter N echo This is
printf "delimiter NUL line 1\0line 2\0line 3" | $PAR -k -d '\0' echo
printf "delimiter TAB line 1\tline 2\tline 3" | $PAR -k --delimiter '\t' echo

echo '### Test --max-chars and -s: Max number of chars in a line'
(echo line 1;echo line 1;echo line 2) | $PAR -k --max-chars 25 -X echo
(echo line 1;echo line 1;echo line 2) | $PAR -k -s 25 -X echo

echo '### Test --no-run-if-empty and -r: This should give no output'
echo "  " | $PAR -r echo
echo "  " | $PAR --no-run-if-empty echo

echo '### Test --help and -h: Help output (just check we get the same amount of lines)'
echo Output from -h and --help
$PAR -h | wc -l
$PAR --help | wc -l

echo '### Test --version: Version output (just check we get the same amount of lines)'
$PAR --version | wc -l

echo '### Test --verbose and -t'
(echo b; echo c; echo f) | $PAR -k -t echo {}ar 2>&1 >/dev/null
(echo b; echo c; echo f) | $PAR -k --verbose echo {}ar 2>&1 >/dev/null

echo '### Test --show-limits'
(echo b; echo c; echo f) | $PAR -k --show-limits echo {}ar
(echo b; echo c; echo f) | $PAR -k --show-limits -s 100 echo {}ar
