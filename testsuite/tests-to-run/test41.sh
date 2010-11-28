#!/bin/bash

SERVER1=parallel-server3
SERVER2=parallel-server2

echo '### Test -M'

seq 1 20 | parallel -k -M -S 9/$SERVER1,9/parallel@$SERVER2 echo
