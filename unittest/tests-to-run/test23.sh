#!/bin/bash

PAR=parallel
SERVER1=parallel-server1
SERVER2=parallel-server2

cd /tmp
(
echo '### Test --basefile + --cleanup + permissions'
echo echo scriptrun '"$@"' > script
chmod 755 script
seq 1 5 | parallel -kS $SERVER1 --cleanup -B script ./script
echo good if no file
stdout ssh $SERVER1 ls 'script' || echo OK

echo '### Test --basefile + --sshlogin :'
echo cat '"$@"' > my_script
chmod 755 my_script
rm -f parallel_*.test parallel_*.out
seq 1 13 | parallel echo {} '>' parallel_{}.test

ls parallel_*.test | parallel -j+0 --trc {.}.out -B my_script \
-S parallel-server1,parallel@parallel-server2,: "./my_script {} > {.}.out"
cat parallel_*.test parallel_*.out
)
