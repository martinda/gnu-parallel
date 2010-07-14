#!/bin/bash

echo '### Test xapply --max-replace-args'
seq 0 7 | parallel -k --max-replace-args=3 echo {3} {2} {1}
echo '### Test -N'
seq 1 5 | parallel -kN3 echo {1} {2} {3}
echo '### Test -N with 0'
seq 0 7 | parallel -kN3 echo {1} {2} {3}
echo '### Test :::: on nonexistent'
stdout parallel -k echo {1} {2} {3} :::: nonexistent
echo '### Test :::: two files'
parallel -k echo {1} {2} :::: <(seq 1 10) <(seq 5 15)
echo '### Test -d, ::::'
parallel -kd, 'echo a{1} {2}b' :::: <(echo 1,2,3,) <(echo 5,6,7,8)
echo '### Test -d, :::: one file too much'
parallel -kd, echo 'a{1}' '{2}b' :::: <(echo 1,2,3,) <(echo 5,6,7,8) <(echo 9,0)
echo '### Bug: did not quote'
parallel echo {1} {2} :::: <(echo '>') <(echo b)
echo '### Quote test triplet 1'
parallel -kv :::: <(echo 'echo a'; echo 'echo b')
parallel -kv -a <(echo 'echo a'; echo 'echo b')
(echo 'echo a'; echo 'echo b') | parallel -kv
echo '### Quote test triplet 2'
parallel -kv echo :::: <(echo 'echo a'; echo 'echo b')
parallel -kv -a <(echo 'echo a'; echo 'echo b') echo
(echo 'echo a'; echo 'echo b') | parallel -kv echo
echo '### Quoting if there is a command and 2 arg files'
parallel -kv echo :::: <(echo 'echo a') <(echo 'echo b')
echo '### Quoting if there is a command and 2 arg files of uneven length'
parallel -kv echo :::: <(echo 'echo a';echo a1) <(echo 'echo b')
echo '### Quoting if there is no command and 2 arg files'
parallel -kv :::: <(echo 'echo a') <(echo 'echo b')
echo '### Quoting if there is no command and 2 arg files of uneven length'
parallel -kv :::: <(echo 'echo a';echo echo a1) <(echo 'echo b')

echo '### Test multiple -a'
parallel -kv -a <(echo a) -a <(echo b) echo {2} {1}
parallel -kv echo {2} {1} :::: <(echo a) <(echo b)
echo '### Multiple -a: An unused file'
parallel -kv -a <(echo a) -a <(echo b) -a <(echo c) echo {2} {1}
parallel -kv echo {2} {1} :::: <(echo a) <(echo b) <(echo c)
echo '### Multiple -a: nonexistent'
stdout parallel -kv echo {2} {1} :::: nonexist nonexist2
stdout parallel -kv -a nonexist -a nonexist2 echo {2} {1}

echo '### Test {#.}'
parallel -kv -a <(echo a-noext) -a <(echo b-withext.extension) -a <(echo c-ext.gif) echo {3.} {2.} {1.}
