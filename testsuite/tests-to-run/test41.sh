#!/bin/bash

SERVER1=parallel-server3
SERVER2=parallel-server2

echo '### Test -M (--retries to avoid false errors)'

seq 1 30 | parallel -j5 --retries 3 -k -M -S $SERVER1,parallel@$SERVER2 echo 2>/dev/null
seq 1 30 | parallel -j10 --retries 3 -k -M -S $SERVER1,parallel@$SERVER2 echo 2>/dev/null
