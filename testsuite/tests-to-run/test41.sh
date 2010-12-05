#!/bin/bash

SERVER1=parallel-server3
SERVER2=parallel-server2

echo '### Test -M'

seq 1 30 | parallel -j5 -k -M -S $SERVER1,parallel@$SERVER2 echo
seq 1 30 | parallel -j10 -k -M -S $SERVER1,parallel@$SERVER2 echo
