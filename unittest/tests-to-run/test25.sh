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
