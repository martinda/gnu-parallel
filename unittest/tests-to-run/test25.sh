#!/bin/bash

echo '### Test basic --arg-sep'
parallel -k echo ::: a b
echo '### Run commands using --arg-sep'
parallel -kv ::: 'echo a' 'echo b'
echo '### Change --arg-sep'
parallel --arg-sep ::: -kv ::: 'echo a' 'echo b'
parallel --arg-sep .--- -kv .--- 'echo a' 'echo b'
echo '### Test stdin goes to first command only'
echo via first cat |parallel -kv cat ::: - -
echo via cat |parallel --arg-sep .--- -kv .--- 'cat' 'echo b'
echo via cat |parallel -kv ::: 'cat' 'echo b'
echo no output |parallel -kv ::: 'echo a' 'cat'

echo '### Bug made 4 5 go before 1 2 3'
parallel -k ::: "sleep 1; echo 1" "echo 2" "echo 3" "echo 4" "echo 5"
echo '### Bug made 3 go before 1 2'
parallel -kj 1 ::: "sleep 1; echo 1" "echo 2" "echo 3"
echo '### Bug did not quote'
echo '>' | parallel -v echo
parallel -v echo ::: '>'
(echo '>'; echo  2) | parallel -vX echo
parallel -X echo ::: '>' 2
echo '### Must not quote'
echo 'echo | wc -l' | parallel -v
parallel -v ::: 'echo | wc -l'
echo 'echo a b c | wc -w' | parallel -v
parallel -kv ::: 'echo a b c | wc -w' 'echo a b | wc -w'
