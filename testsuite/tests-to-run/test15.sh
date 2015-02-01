#!/bin/bash

# Test xargs compatibility

rm -f ~/.parallel/will-cite

echo '### Test -p --interactive'
cat >/tmp/parallel-script-for-expect <<_EOF
#!/bin/bash

seq 1 3 | parallel -k -p "sleep 0.1; echo opt-p"
seq 1 3 | parallel -k --interactive "sleep 0.1; echo opt--interactive"
_EOF
chmod 755 /tmp/parallel-script-for-expect

expect -b - <<_EOF
spawn /tmp/parallel-script-for-expect
expect "echo opt-p 1"
send "y\n"
expect "echo opt-p 2"
send "n\n"
expect "echo opt-p 3"
send "y\n"
expect "opt-p 1"
expect "opt-p 3"
expect "echo opt--interactive 1"
send "y\n"
expect "echo opt--interactive 2"
send "n\n"
expect "opt--interactive 1"
expect "echo opt--interactive 3"
send "y\n"
expect "opt--interactive 3"
_EOF
echo
cat <<'EOF' | parallel -vj0 -k -L1
echo '### Test killing children with --timeout and exit value (failed if timed out)'
  pstree $$ | grep sleep | grep -v anacron | grep -v screensave | wc; 
  parallel --timeout 3 'true {} ; for i in `seq 100 120`; do bash -c "(sleep $i)" & sleep $i & done; wait; echo No good' ::: 1000000000 1000000001 ; 
  echo $?; sleep 2; pstree $$ | grep sleep | grep -v anacron | grep -v screensave | wc

echo '### Test -L -l and --max-lines'
(echo a_b;echo c) | parallel -km -L2 echo
(echo a_b;echo c) | parallel -k -L2 echo
(echo a_b;echo c) | xargs -L2 echo
echo '### xargs -L1 echo'
(echo a_b;echo c) | parallel -km -L1 echo
(echo a_b;echo c) | parallel -k -L1 echo
(echo a_b;echo c) | xargs -L1 echo
echo 'Lines ending in space should continue on next line'
echo '### xargs -L1 echo'
(echo a_b' ';echo c;echo d) | parallel -km -L1 echo
(echo a_b' ';echo c;echo d) | parallel -k -L1 echo
(echo a_b' ';echo c;echo d) | xargs -L1 echo
echo '### xargs -L2 echo'
(echo a_b' ';echo c;echo d;echo e) | parallel -km -L2 echo
(echo a_b' ';echo c;echo d;echo e) | parallel -k -L2 echo
(echo a_b' ';echo c;echo d;echo e) | xargs -L2 echo
echo '### xargs -l echo'
(echo a_b' ';echo c;echo d;echo e) | parallel -l -km echo # This behaves wrong
(echo a_b' ';echo c;echo d;echo e) | parallel -l -k echo # This behaves wrong
(echo a_b' ';echo c;echo d;echo e) | xargs -l echo
echo '### xargs -l2 echo'
(echo a_b' ';echo c;echo d;echo e) | parallel -km -l2 echo
(echo a_b' ';echo c;echo d;echo e) | parallel -k -l2 echo
(echo a_b' ';echo c;echo d;echo e) | xargs -l2 echo
echo '### xargs -l1 echo'
(echo a_b' ';echo c;echo d;echo e) | parallel -km -l1 echo
(echo a_b' ';echo c;echo d;echo e) | parallel -k -l1 echo
(echo a_b' ';echo c;echo d;echo e) | xargs -l1 echo
echo '### xargs --max-lines=2 echo'
(echo a_b' ';echo c;echo d;echo e) | parallel -km --max-lines 2 echo
(echo a_b' ';echo c;echo d;echo e) | parallel -k --max-lines 2 echo
(echo a_b' ';echo c;echo d;echo e) | xargs --max-lines=2 echo
echo '### xargs --max-lines echo'
(echo a_b' ';echo c;echo d;echo e) | parallel --max-lines -km echo # This behaves wrong
(echo a_b' ';echo c;echo d;echo e) | parallel --max-lines -k echo # This behaves wrong
(echo a_b' ';echo c;echo d;echo e) | xargs --max-lines echo

echo '### test too long args'
perl -e 'print "z"x1000000' | parallel echo 2>&1
perl -e 'print "z"x1000000' | xargs echo 2>&1
(seq 1 10; perl -e 'print "z"x1000000'; seq 12 15) | stdout parallel -j1 -km -s 10 echo
(seq 1 10; perl -e 'print "z"x1000000'; seq 12 15) | stdout xargs -s 10 echo
(seq 1 10; perl -e 'print "z"x1000000'; seq 12 15) | stdout parallel -j1 -kX -s 10 echo
echo '### Test -x'
(seq 1 10; echo 12345; seq 12 15) | stdout parallel -j1 -km -s 10 -x echo
(seq 1 10; echo 12345; seq 12 15) | stdout parallel -j1 -kX -s 10 -x echo
(seq 1 10; echo 12345; seq 12 15) | stdout xargs -s 10 -x echo
(seq 1 10; echo 1234; seq 12 15) | stdout parallel -j1 -km -s 10 -x echo
(seq 1 10; echo 1234; seq 12 15) | stdout parallel -j1 -kX -s 10 -x echo
(seq 1 10; echo 1234; seq 12 15) | stdout xargs -s 10 -x echo

echo '### Test -a and --arg-file: Read input from file instead of stdin'
seq 1 10 >/tmp/parallel_$$-1; parallel -k -a /tmp/parallel_$$-1 echo; rm /tmp/parallel_$$-1
seq 1 10 >/tmp/parallel_$$-2; parallel -k --arg-file /tmp/parallel_$$-2 echo; rm /tmp/parallel_$$-2

EOF

#echo '### Test bugfix if no command given'
#(echo echo; seq 1 5; perl -e 'print "z"x1000000'; seq 12 15) | stdout parallel -j1 -km -s 10

cd input-files/test15

echo 'xargs Expect: 3 1 2'
echo 3 | xargs -P 1 -n 1 -a files cat -
echo 'parallel Expect: 3 1 via psedotty  2'
cat >/tmp/parallel-script-for-script <<EOF
#!/bin/bash
echo 3 | parallel --tty -k -P 1 -n 1 -a files cat -
EOF
chmod 755 /tmp/parallel-script-for-script
echo via pseudotty | script -q -f -c /tmp/parallel-script-for-script /dev/null
sleep 1

echo 'xargs Expect: 1 3 2'
echo 3 | xargs -I {} -P 1 -n 1 -a files cat {} -
echo 'parallel Expect: 1 3 2 via pseudotty'
cat >/tmp/parallel-script-for-script2 <<EOF
#!/bin/bash
echo 3 | parallel --tty -k -I {} -P 1 -n 1 -a files cat {} -
EOF
chmod 755 /tmp/parallel-script-for-script2
echo via pseudotty | script -q -f -c /tmp/parallel-script-for-script2 /dev/null
sleep 1

echo '### Hans found a bug giving unitialized variable'
echo >/tmp/parallel_f1
echo >/tmp/parallel_f2'
'
echo /tmp/parallel_f1 /tmp/parallel_f2 | stdout parallel -kv --delimiter ' ' gzip
rm /tmp/parallel_f*


cat <<'EOF' | sed -e 's/;$/; /;s/$SERVER1/'$SERVER1'/;s/$SERVER2/'$SERVER2'/' | stdout parallel -vj10 -k --joblog /tmp/jl-`basename $0` -L1
echo '### Test -i and --replace: Replace with argument'
(echo a; echo END; echo b) | parallel -k -i -eEND echo repl{}ce
(echo a; echo END; echo b) | parallel -k --replace -eEND echo repl{}ce
(echo a; echo END; echo b) | parallel -k -i+ -eEND echo repl+ce
(echo e; echo END; echo b) | parallel -k -i'*' -eEND echo r'*'plac'*'
(echo a; echo END; echo b) | parallel -k --replace + -eEND echo repl+ce
(echo a; echo END; echo b) | parallel -k --replace== -eEND echo repl=ce
(echo a; echo END; echo b) | parallel -k --replace = -eEND echo repl=ce
(echo a; echo END; echo b) | parallel -k --replace=^ -eEND echo repl^ce
(echo a; echo END; echo b) | parallel -k -I^ -eEND echo repl^ce

echo '### Test -E: Artificial end-of-file'
(echo include this; echo END; echo not this) | parallel -k -E END echo
(echo include this; echo END; echo not this) | parallel -k -EEND echo

echo '### Test -e and --eof: Artificial end-of-file'
(echo include this; echo END; echo not this) | parallel -k -e END echo
(echo include this; echo END; echo not this) | parallel -k -eEND echo
(echo include this; echo END; echo not this) | parallel -k --eof=END echo
(echo include this; echo END; echo not this) | parallel -k --eof END echo

echo '### Test -n and --max-args: Max number of args per line (only with -X and -m)'
(echo line 1;echo line 2;echo line 3) | parallel -k -n1 -m echo
(echo line 1;echo line 1;echo line 2) | parallel -k -n2 -m echo
(echo line 1;echo line 2;echo line 3) | parallel -k -n1 -X echo
(echo line 1;echo line 1;echo line 2) | parallel -k -n2 -X echo
(echo line 1;echo line 2;echo line 3) | parallel -k -n1 echo
(echo line 1;echo line 1;echo line 2) | parallel -k -n2 echo
(echo line 1;echo line 2;echo line 3) | parallel -k --max-args=1 -X echo
(echo line 1;echo line 2;echo line 3) | parallel -k --max-args 1 -X echo
(echo line 1;echo line 1;echo line 2) | parallel -k --max-args=2 -X echo
(echo line 1;echo line 1;echo line 2) | parallel -k --max-args 2 -X echo
(echo line 1;echo line 2;echo line 3) | parallel -k --max-args 1 echo
(echo line 1;echo line 1;echo line 2) | parallel -k --max-args 2 echo

echo '### Test --max-procs and -P: Number of processes'
seq 1 10 | parallel -k --max-procs +0 echo max proc
seq 1 10 | parallel -k -P 200% echo 200% proc

echo '### Test --delimiter and -d: Delimiter instead of newline'
echo '# Yes there is supposed to be an extra newline for -d N'
echo line 1Nline 2Nline 3 | parallel -k -d N echo This is
echo line 1Nline 2Nline 3 | parallel -k --delimiter N echo This is
printf "delimiter NUL line 1\0line 2\0line 3" | parallel -k -d '\0' echo
printf "delimiter TAB line 1\tline 2\tline 3" | parallel -k --delimiter '\t' echo

echo '### Test --max-chars and -s: Max number of chars in a line'
(echo line 1;echo line 1;echo line 2) | parallel -k --max-chars 25 -X echo
(echo line 1;echo line 1;echo line 2) | parallel -k -s 25 -X echo

echo '### Test --no-run-if-empty and -r: This should give no output'
echo "  " | parallel -r echo
echo "  " | parallel --no-run-if-empty echo

echo '### Test --help and -h: Help output (just check we get the same amount of lines)'
echo Output from -h and --help
parallel -h | wc -l
parallel --help | wc -l

echo '### Test --version: Version output (just check we get the same amount of lines)'
parallel --version | wc -l

echo '### Test --verbose and -t'
(echo b; echo c; echo f) | parallel -k -t echo {}ar 2>&1 >/dev/null
(echo b; echo c; echo f) | parallel -k --verbose echo {}ar 2>&1 >/dev/null

echo '### Test --show-limits'
(echo b; echo c; echo f) | parallel -k --show-limits echo {}ar
(echo b; echo c; echo f) | parallel -j1 -kX --show-limits -s 100 echo {}ar

echo '### Test empty line as input'
echo | parallel echo empty input line

echo '### Tests if (cat | sh) works'
perl -e 'for(1..25) {print "echo a $_; echo b $_\n"}' | parallel 2>&1 | sort

echo '### Test if xargs-mode works'
perl -e 'for(1..25) {print "a $_\nb $_\n"}' | parallel echo 2>&1 | sort

echo '### Test -q'
parallel -kq perl -e '$ARGV[0]=~/^\S+\s+\S+$/ and print $ARGV[0],"\n"' ::: "a b" c "d e f" g "h i"

echo '### Test -q {#}'
parallel -kq echo {#} ::: a b
parallel -kq echo {\#} ::: a b
parallel -kq echo {\\#} ::: a b

echo '### Test long commands do not take up all memory'
seq 1 100 | parallel -j0 -qv perl -e '$r=rand(shift);for($f=0;$f<$r;$f++){$a="a"x100};print shift,"\n"' 10000 2>/dev/null | sort

echo '### Test 0-arguments'
seq 1 2 | parallel -k -n0 echo n0
seq 1 2 | parallel -k -L0 echo L0
seq 1 2 | parallel -k -N0 echo N0

echo '### Because of --tollef -l, then -l0 == -l1, sorry'
seq 1 2 | parallel -k -l0 echo l0

echo '### Test replace {}'
seq 1 2 | parallel -k -N0 echo replace {} curlies

echo '### Test arguments on commandline'
parallel -k -N0 echo args on cmdline ::: 1 2

echo '### Test --nice locally'
parallel --nice 1 -vv 'PAR=a bash -c "echo  \$PAR {}"' ::: b

echo '### Test --nice remote'
stdout parallel --nice 1 -S .. -vv 'PAR=a bash -c "echo  \$PAR {}"' ::: b | 
  perl -pe 's/\S*parallel-server\S*/one-server/;s/[a-f0-9]{500,}/hex/;s/\d{5,8}/pId/g;'

echo '### Test distribute arguments at EOF to 2 jobslots'
seq 1 92 | parallel -j+0 -kX -s 100 echo

echo '### Test distribute arguments at EOF to 5 jobslots'
seq 1 92 | parallel -j+3 -kX -s 100 echo

echo '### Test distribute arguments at EOF to infinity jobslots'
seq 1 92 | parallel -j0 -kX -s 100 echo 2>/dev/null

echo '### Test -N is not broken by distribution - single line'
seq 9 | parallel  -N 10  echo

echo '### Test -N is not broken by distribution - two lines'
seq 19 | parallel -k -N 10  echo

echo '### Test -N context replace'
seq 19 | parallel -k -N 10  echo a{}b

echo '### Test -L context replace'
seq 19 | parallel -k -L 10  echo a{}b
EOF

touch ~/.parallel/will-cite
