#!/bin/bash

echo '### Test of --retries'
seq 1 10 | parallel -k --retries 2 -v -S 4.3.2.1,: echo

echo '### Test of --retries - it should run 13 jobs in total'
seq 0 12 | parallel --progress -kj100% --retries 1 -S 12/nlv.pi.dk,1/:,parallel@server2 -vq \
 perl -e 'sleep 1;print "job{}\n";exit({})' | tail -n1 | \
 perl -ne '@a=(split /\//,$_); print $a[1]+$a[4]+$a[7],"\n"'

echo '### Test of --retries - it should run 25 jobs in total'
seq 0 12 | parallel --progress -kj100% --retries 2 -S 12/nlv.pi.dk,1/:,parallel@server2 -vq \
 perl -e 'sleep 1;print "job{}\n";exit({})' | tail -n1 | \
 perl -ne '@a=(split /\//,$_); print $a[1]+$a[4]+$a[7],"\n"'

echo '### Test of --retries - it should run 49 jobs in total'
seq 0 12 | parallel --progress -kj100% --retries 4 -S 12/nlv.pi.dk,1/:,parallel@server2 -vq \
 perl -e 'sleep 1;print "job{}\n";exit({})' | tail -n1 | \
 perl -ne '@a=(split /\//,$_); print $a[1]+$a[4]+$a[7],"\n"'

