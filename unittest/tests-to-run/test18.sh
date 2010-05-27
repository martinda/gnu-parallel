#!/bin/bash

PAR=parallel

SERVER1=parallel-server1
SERVER2=parallel-server2

echo '### Check warning if --transfer but file not found'
echo /tmp/noexistant/file | stdout $PAR -k -S $SERVER1 --transfer echo

echo '### Check warning if --transfer but not --sshlogin'
echo | stdout $PAR -k --transfer echo

echo '### Check warning if --return but not --sshlogin'
echo | stdout $PAR -k --return {} echo

echo '### Check warning if --cleanup but not --sshlogin'
echo | stdout $PAR -k --cleanup echo

echo '### Test --sshlogin -S --sshloginfile'
echo localhost >/tmp/parallel-sshlogin
seq 1 3 | $PAR -k --sshlogin 8/$SERVER1 -S "7/ssh -l parallel $SERVER2",: --sshloginfile /tmp/parallel-sshlogin echo

echo '### Test --sshloginfile with extra content'
echo "2/ssh -l parallel $SERVER2" >>/tmp/parallel-sshlogin
echo ":" >>/tmp/parallel-sshlogin
echo "#2/ssh -l tange nothing" >>/tmp/parallel-sshlogin
seq 1 10 | $PAR -k --sshloginfile /tmp/parallel-sshlogin echo

echo '### Check forced number of CPUs being respected'
stdout cat /tmp/test17 | parallel -k -j+0  -S 1/:,9/$SERVER1  "hostname; echo {} >/dev/null"

echo '### Check more than 9 simultaneous sshlogins'
seq 1 11 | $PAR -k -j0 -S "/ssh $SERVER1" echo

echo '### Check more than 9(relative) simultaneous sshlogins'
seq 1 11 | $PAR -k -j10000% -S "ssh $SERVER1" echo

echo '### Check -S syntax'
seq 1 11 | $PAR -k -j100% -S "/:" echo


