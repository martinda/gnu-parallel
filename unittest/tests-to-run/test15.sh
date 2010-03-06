#!/bin/bash

# Test xargs compatibility


# Test -a and --arg-file: Read input from file instead of stdin
seq 1 10 >/tmp/$$
parallel -a /tmp/$$ echo
parallel --arg-file /tmp/$$ echo

# Test -i and --replace: Replace with argument
(echo a; echo END; echo b) | parallel -k -i -eEND echo repl{}ce
(echo a; echo END; echo b) | parallel -k --replace -eEND echo repl{}ce
(echo a; echo END; echo b) | parallel -k -i+ -eEND echo repl+ce
(echo e; echo END; echo b) | parallel -k -i'*' -eEND echo r'*'plac'*'
(echo a; echo END; echo b) | parallel -k --replace + -eEND echo repl+ce
(echo a; echo END; echo b) | parallel -k --replace== -eEND echo repl=ce
(echo a; echo END; echo b) | parallel -k --replace = -eEND echo repl=ce
(echo a; echo END; echo b) | parallel -k --replace=^ -eEND echo repl^ce
(echo a; echo END; echo b) | parallel -k -I^ -eEND echo repl^ce

# Test -E: Artificial end-of-file
(echo include this; echo END; echo not this) | parallel -k -E END echo
(echo include this; echo END; echo not this) | parallel -k -EEND echo

# Test -e and --eof: Artificial end-of-file
(echo include this; echo END; echo not this) | parallel -k -e END echo
(echo include this; echo END; echo not this) | parallel -k -eEND echo
(echo include this; echo END; echo not this) | parallel -k --eof=END echo
(echo include this; echo END; echo not this) | parallel -k --eof END echo

# Test -n and --max-args: Max number of args per line (only with -X and -m)
(echo line 1;echo line 2;echo line 3) | parallel -k -n1 -m echo
(echo line 1;echo line 1;echo line 2) | parallel -k -n2 -m echo
(echo line 1;echo line 2;echo line 3) | parallel -k -n1 -X echo
(echo line 1;echo line 1;echo line 2) | parallel -k -n2 -X echo
(echo line 1;echo line 2;echo line 3) | parallel -k --max-args=1 -X echo
(echo line 1;echo line 2;echo line 3) | parallel -k --max-args 1 -X echo
(echo line 1;echo line 1;echo line 2) | parallel -k --max-args=2 -X echo
(echo line 1;echo line 1;echo line 2) | parallel -k --max-args 2 -X echo

# Test --max-procs and -P: Number of processes
seq 1 10 | parallel -k --max-procs +0 echo 
seq 1 10 | parallel -k -P 200% echo 

# Test --delimiter and -d: Delimiter instead of newline
# Yes there is supposed to be an extra newline for -d N
echo line 1Nline 2Nline 3 | parallel -k -d N echo This is
echo line 1Nline 2Nline 3 | parallel -k --delimiter N echo This is
printf "line 1\0line 2\0line 3" | parallel -d '\0' echo
printf "line 1\tline 2\tline 3" | parallel --delimiter '\t' echo

# Test --max-chars and -s: Max number of chars in a line
(echo line 1;echo line 1;echo line 2) | parallel -k --max-chars 25 -X echo
(echo line 1;echo line 1;echo line 2) | parallel -k -s 25 -X echo

# Test --no-run-if-empty and -r: This should give no output
echo "  " | parallel -r echo
echo "  " | parallel --no-run-if-empty echo

# Test --help and -h: Help output (just check we get the same amount of lines)
parallel -h | wc -l
parallel --help | wc -l

# Test --version: Version output (just check we get the same amount of lines)
parallel --version | wc -l

# Test --verbose and -t
(echo b; echo c; echo f) | parallel -k -t echo {}ar 2>&1 >/dev/null
(echo b; echo c; echo f) | parallel -k --verbose echo {}ar 2>&1 >/dev/null
