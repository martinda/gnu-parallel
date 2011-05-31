#!/bin/bash

SERVER1=parallel-server3
SERVER2=parallel-server2

echo '### Test --return of weirdly named file'
stdout parallel --return {} -vv -S $SERVER1 echo '>'{} ::: 'aa<${#}" b'
rm 'aa<${#}" b'
