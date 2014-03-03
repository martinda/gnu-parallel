#!/bin/bash

echo "### These tests requires VirtualBox running with the following images"
echo `whoami`"@freebsd7"

VBoxManage startvm FreeBSD71 >/dev/null 2>&1
ping -c 1 freebsd7.tange.dk >/dev/null 2>&1

ssh freebsd7.tange.dk touch .parallel/will-cite
scp -q .*/src/{parallel,sem,sql,niceload} freebsd7.tange.dk:bin/

cat <<'EOF' | sed -e 's/$SERVER1/'$SERVER1'/;s/$SERVER2/'$SERVER2'/' | stdout parallel -k -S freebsd7.tange.dk -j4 
echo 'bug #40136: FreeBSD: No more processes'
# Long line due to FreeBSD's /bin/sh stupidity
  sem --jobs 3 --id my_id -u 'echo First started; sleep 5; echo The first finished' &&   sem --jobs 3 --id my_id -u 'echo Second started; sleep 6; echo The second finished' &&   sem --jobs 3 --id my_id -u 'echo Third started; sleep 7; echo The third finished' &&   sem --jobs 3 --id my_id -u 'echo Fourth started; sleep 8; echo The fourth finished' &&   sem --wait --id my_id

echo 'Test --compress --pipe'
  jot 1000 | parallel --compress --pipe cat | wc

echo 'bug #41613: --compress --line-buffer no newline';
  perl -e 'print "It worked"'| parallel --pipe --compress --line-buffer cat; echo

echo 'bug #40135: FreeBSD: sem --fg does not finish under /bin/sh'
  sem --fg 'sleep 1; echo The job finished' 

echo 'bug #40133: FreeBSD: --round-robin gives no output'
  jot 1000000 | parallel --round-robin --pipe -kj3 wc | sort
  jot 1000000 | parallel --round-robin --pipe -kj4 wc | sort

EOF

VBoxManage controlvm FreeBSD71 savestate



