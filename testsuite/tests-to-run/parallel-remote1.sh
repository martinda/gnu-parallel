#!/bin/bash

SERVER1=parallel-server3
SERVER2=lo
SSHLOGIN1=parallel@parallel-server3
SSHLOGIN2=parallel@lo

echo '### Test use special ssh with > 9 simultaneous'
echo 'ssh "$@"; echo "$@" >>/tmp/myssh1-run' >/tmp/myssh1
echo 'ssh "$@"; echo "$@" >>/tmp/myssh2-run' >/tmp/myssh2
chmod 755 /tmp/myssh1 /tmp/myssh2
seq 1 100 | parallel --sshlogin "/tmp/myssh1 $SSHLOGIN1, /tmp/myssh2 $SSHLOGIN2" \
  -j10000% -k echo
