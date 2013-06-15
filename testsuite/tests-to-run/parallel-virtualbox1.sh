#!/bin/bash

echo "### These tests requires VirtualBox running with the following images"
echo `whoami`"@redhat9"
echo `whoami`"@centos3"
echo `whoami`"@centos5"
echo `whoami`"@freebsd7"

VBoxManage startvm CentOS3-root:centos3 >/dev/null 2>&1
VBoxManage startvm CentOS5-root:centos5 >/dev/null 2>&1
VBoxManage startvm RedHat9-root:redhat9 >/dev/null 2>&1
VBoxManage startvm FreeBSD71 >/dev/null 2>&1

echo "### bug #37589: Red Hat 9 (Shrike) perl v5.8.0 built for i386-linux-thread-multi error"
cp `which parallel` /tmp/parallel
stdout parallel -kj10 --argsep == --basefile /tmp/parallel --tag --nonall -S redhat9.tange.dk,centos3.tange.dk,centos5.tange.dk,freebsd7.tange.dk /tmp/parallel echo ::: OK_if_no_perl_warnings | sort

#VBoxManage controlvm CentOS3-root:centos3 savestate
VBoxManage controlvm CentOS5-root:centos5 savestate
#VBoxManage controlvm RedHat9-root:redhat9 savestate
VBoxManage controlvm FreeBSD71 savestate
