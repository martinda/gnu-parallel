#!/bin/bash

PAR=parallel

# Test sshlogin
echo localhost >/tmp/localhost
seq 1 3 | $PAR -k --sshlogin 8/nlv.pi.dk -S 7/"-l tange nlv.pi.dk",: --sshloginfile /tmp/localhost echo

(seq 1 3;echo '>/tmp/fire';seq 5 10) | parallel -k -v -j+0  -S nlv.pi.dk,:  "sleep 1; echo {}"
# Check number of CPUs being respected
(seq 1 3;echo '>/tmp/fire';seq 5 10) | parallel -k -v -j+0  -S 1/:,9/nlv.pi.dk  "sleep 1; hostname; echo {}"
