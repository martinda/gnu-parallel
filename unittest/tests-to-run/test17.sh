#!/bin/bash

PAR=parallel

# Test sshlogin
echo localhost >/tmp/localhost
seq 1 3 | $PAR --sshlogin 8/al -S 7/"-l eiipe fod",: --sshloginfile /tmp/localhost echo
