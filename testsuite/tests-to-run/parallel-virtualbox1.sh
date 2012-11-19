#!/bin/bash

echo "### These tests requires VirtualBox running with the following images"
echo `whoami`"@redhat9"
echo `whoami`"@centos3"
echo `whoami`"@centos5"
echo `whoami`"@freebsd7"

echo "### bug #37589: Red Hat 9 (Shrike) perl v5.8.0 built for i386-linux-thread-multi error"
cp `which parallel` /tmp/parallel
stdout parallel -j10 --argsep == --basefile /tmp/parallel --tag --nonall -S redhat9.tange.dk,centos3.tange.dk,centos5.tange.dk,freebsd7.tange.dk /tmp/parallel echo ::: OK_if_no_perl_warnings | sort
