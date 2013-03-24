#!/bin/bash

SERVER1=parallel-server1
SERVER2=parallel-server2
SSHLOGIN1=parallel@$SERVER1
SSHLOGIN2=parallel@$SERVER2

cd /tmp

echo '### Test --basefile with no --sshlogin'
echo | stdout parallel --basefile foo echo 

echo '### Test --basefile + --cleanup + permissions'
echo echo script1 run '"$@"' > script1
echo echo script2 run '"$@"' > script2
chmod 755 script1 script2
seq 1 5 | parallel -kS $SSHLOGIN1 --cleanup --bf script1 --basefile script2 "./script1 {};./script2 {}"
echo good if no file
stdout ssh $SSHLOGIN1 ls 'script1' || echo OK
stdout ssh $SSHLOGIN1 ls 'script2' || echo OK

echo '### Test --basefile + --sshlogin :'
echo cat '"$@"' > my_script
chmod 755 my_script
rm -f parallel_*.test parallel_*.out
seq 1 13 | parallel echo {} '>' parallel_{}.test

ls parallel_*.test | parallel -j+0 --trc {.}.out --bf my_script \
-S $SSHLOGIN1,$SSHLOGIN2,: "./my_script {} > {.}.out"
cat parallel_*.test parallel_*.out

## Broken since 2013-03-23
## rm -rf tmp
## echo "### Test combined -X --return {/}_{/.}_{#/.}_{#/}_{#.} with files containing space"
## stdout parallel -j1 -k -Xv --cleanup --return tmp/{/}_{/.}_{2/.}_{2/}_{2.}/file -S $SSHLOGIN2 \
## mkdir -p tmp/{/}_{/.}_{2/.}_{2/}_{2.} \;touch tmp/{/}_{/.}_{2/.}_{2/}_{2.}/file \
## ::: /a/number1.c a/number2.c number3.c /a/number4 a/number5 number6 'number 7' 'number <8|8>'
## find tmp | sort
## rm -rf tmp

echo "### Here we ought to test -m --return {/}_{/.}_{#/.}_{#/}_{#.} with files containing space"
echo "### But we will wait for a real world scenario"
