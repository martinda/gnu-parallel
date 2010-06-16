#!/bin/bash

PAR=parallel
SERVER1=parallel-server3
SERVER2=parallel-server2

cd /tmp

echo '### Test --basefile with no --sshlogin'
echo | stdout parallel --basefile foo echo 

echo '### Test --basefile + --cleanup + permissions'
echo echo script1 run '"$@"' > script1
echo echo script2 run '"$@"' > script2
chmod 755 script1 script2
seq 1 5 | parallel -kS $SERVER1 --cleanup -B script1 --basefile script2 "./script1 {};./script2 {}"
echo good if no file
stdout ssh $SERVER1 ls 'script1' || echo OK
stdout ssh $SERVER1 ls 'script2' || echo OK

echo '### Test --basefile + --sshlogin :'
echo cat '"$@"' > my_script
chmod 755 my_script
rm -f parallel_*.test parallel_*.out
seq 1 13 | parallel echo {} '>' parallel_{}.test

ls parallel_*.test | parallel -j+0 --trc {.}.out -B my_script \
-S $SERVER1,parallel@$SERVER2,: "./my_script {} > {.}.out"
cat parallel_*.test parallel_*.out

