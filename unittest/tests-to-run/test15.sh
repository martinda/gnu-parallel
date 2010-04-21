#!/bin/bash

# Test xargs compatibility

PAR=parallel

# Test -a and --arg-file: Read input from file instead of stdin
seq 1 10 >/tmp/$$
$PAR -a /tmp/$$ echo
$PAR --arg-file /tmp/$$ echo

cd input-files/test15

# echo 3 | xargs -P 2 -n 1 -a files cat -
echo 3 | parallel -k -P 2 -n 1 -a files cat -
# echo 3 | xargs -I {} -P 2 -n 1 -a files cat {} -
# Should give:
# 3
# 1
# 2
echo 3 | parallel -k -I {} -P 2 -n 1 -a files cat {} -

# Test -i and --replace: Replace with argument
(echo a; echo END; echo b) | $PAR -k -i -eEND echo repl{}ce
(echo a; echo END; echo b) | $PAR -k --replace -eEND echo repl{}ce
(echo a; echo END; echo b) | $PAR -k -i+ -eEND echo repl+ce
(echo e; echo END; echo b) | $PAR -k -i'*' -eEND echo r'*'plac'*'
(echo a; echo END; echo b) | $PAR -k --replace + -eEND echo repl+ce
(echo a; echo END; echo b) | $PAR -k --replace== -eEND echo repl=ce
(echo a; echo END; echo b) | $PAR -k --replace = -eEND echo repl=ce
(echo a; echo END; echo b) | $PAR -k --replace=^ -eEND echo repl^ce
(echo a; echo END; echo b) | $PAR -k -I^ -eEND echo repl^ce

# Test -E: Artificial end-of-file
(echo include this; echo END; echo not this) | $PAR -k -E END echo
(echo include this; echo END; echo not this) | $PAR -k -EEND echo

# Test -e and --eof: Artificial end-of-file
(echo include this; echo END; echo not this) | $PAR -k -e END echo
(echo include this; echo END; echo not this) | $PAR -k -eEND echo
(echo include this; echo END; echo not this) | $PAR -k --eof=END echo
(echo include this; echo END; echo not this) | $PAR -k --eof END echo

# Test -n and --max-args: Max number of args per line (only with -X and -m)
(echo line 1;echo line 2;echo line 3) | $PAR -k -n1 -m echo
(echo line 1;echo line 1;echo line 2) | $PAR -k -n2 -m echo
(echo line 1;echo line 2;echo line 3) | $PAR -k -n1 -X echo
(echo line 1;echo line 1;echo line 2) | $PAR -k -n2 -X echo
(echo line 1;echo line 2;echo line 3) | $PAR -k --max-args=1 -X echo
(echo line 1;echo line 2;echo line 3) | $PAR -k --max-args 1 -X echo
(echo line 1;echo line 1;echo line 2) | $PAR -k --max-args=2 -X echo
(echo line 1;echo line 1;echo line 2) | $PAR -k --max-args 2 -X echo

# Test --max-procs and -P: Number of processes
seq 1 10 | $PAR -k --max-procs +0 echo max proc
seq 1 10 | $PAR -k -P 200% echo 200% proc

# Test --delimiter and -d: Delimiter instead of newline
# Yes there is supposed to be an extra newline for -d N
echo line 1Nline 2Nline 3 | $PAR -k -d N echo This is
echo line 1Nline 2Nline 3 | $PAR -k --delimiter N echo This is
printf "delimiter NUL line 1\0line 2\0line 3" | $PAR -k -d '\0' echo
printf "delimiter TAB line 1\tline 2\tline 3" | $PAR -k --delimiter '\t' echo

# Test --max-chars and -s: Max number of chars in a line
(echo line 1;echo line 1;echo line 2) | $PAR -k --max-chars 25 -X echo
(echo line 1;echo line 1;echo line 2) | $PAR -k -s 25 -X echo

# Test --no-run-if-empty and -r: This should give no output
echo "  " | $PAR -r echo
echo "  " | $PAR --no-run-if-empty echo

# Test --help and -h: Help output (just check we get the same amount of lines)
echo Output from -h and --help
$PAR -h | wc -l
$PAR --help | wc -l

# Test --version: Version output (just check we get the same amount of lines)
$PAR --version | wc -l

# Test --verbose and -t
(echo b; echo c; echo f) | $PAR -k -t echo {}ar 2>&1 >/dev/null
(echo b; echo c; echo f) | $PAR -k --verbose echo {}ar 2>&1 >/dev/null

# Test --show-limits
(echo b; echo c; echo f) | $PAR -k --show-limits echo {}ar
(echo b; echo c; echo f) | $PAR -k --show-limits -s 100 echo {}ar
