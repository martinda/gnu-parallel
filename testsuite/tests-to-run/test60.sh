#!/bin/bash

SERVER1=parallel-server3
SERVER2=parallel-server2

echo '### Test --onall'
parallel --onall -S parallel@$SERVER2,$SERVER1 '(echo {3} {2}) | awk \{print\ \$2}' ::: a b c ::: 1 2 3
echo '### Test | --onall'
seq 3 | parallel --onall -S parallel@$SERVER2,$SERVER1 '(echo {3} {2}) | awk \{print\ \$2}' ::: a b c :::: -
echo '### Test --onall -u'
parallel --onall -S parallel@$SERVER2,$SERVER1 -u '(echo {3} {2}) | awk \{print\ \$2}' ::: a b c ::: 1 2 3 | sort

echo '### Test --nonall'
parallel --nonall -S parallel@$SERVER2,$SERVER1 'hostname'
parallel --nonall -S parallel@$SERVER2,$SERVER1 -u 'hostname;sleep 2;hostname'

