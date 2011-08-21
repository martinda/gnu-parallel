#!/bin/bash

#cat <<'EOF' | sed -e s/\$SERVER1/$SERVER1/\;s/\$SERVER2/$SERVER2/ | nice timeout -k 1 40 parallel -j0 -k -L1
echo '### Test of --retries - it should run 13 jobs in total'; 
  seq 0 12 | stdout parallel --progress -kj100% --retries 1 -S 12/localhost,1/:,parallel@server2 -vq \
  perl -e 'sleep 1;print "job{}\n";exit({})' | 
  perl -ne 'BEGIN{$/="\r";} @a=(split /\//,$_); END{print $a[1]+$a[4]+$a[7],"\n"}'

echo '### Test of --retries - it should run 25 jobs in total'; 
  seq 0 12 | stdout parallel --progress -kj100% --retries 2 -S 12/localhost,1/:,parallel@server2 -vq \
  perl -e 'sleep 1;print "job{}\n";exit({})' | 
  perl -ne 'BEGIN{$/="\r";} @a=(split /\//,$_); END{print $a[1]+$a[4]+$a[7],"\n"}'

echo '### Test of --retries - it should run 49 jobs in total'; 
  seq 0 12 | stdout parallel --progress -kj100% --retries 4 -S 12/localhost,1/:,parallel@server2 -vq \
  perl -e 'sleep 1;print "job{}\n";exit({})' | 
  perl -ne 'BEGIN{$/="\r";} @a=(split /\//,$_); END{print $a[1]+$a[4]+$a[7],"\n"}'
#EOF
echo '### Bug with --retries'
seq 1 8 | parallel --retries 2 --sshlogin 8/localhost,8/: -j+0 "hostname; false" | wc -l
seq 1 8 | parallel --retries 2 --sshlogin 8/localhost,8/: -j+1 "hostname; false" | wc -l
seq 1 2 | parallel --retries 2 --sshlogin 8/localhost,8/: -j-1 "hostname; false" | wc -l
seq 1 1 | parallel --retries 2 --sshlogin 1/localhost,1/: -j1 "hostname; false"	 | wc -l
seq 1 1 | parallel --retries 2 --sshlogin 1/localhost,1/: -j9 "hostname; false"	 | wc -l
seq 1 1 | parallel --retries 2 --sshlogin 1/localhost,1/: -j0 "hostname; false"	 | wc -l
seq 1 1 | parallel --retries 2 --sshlogin 1/localhost,1/: -j-1 "hostname; false" | wc -l

echo '### These were not affected by the bug'
seq 1 8 | parallel --retries 2 --sshlogin 1/localhost,9/: -j-1 "hostname; false" | wc -l
seq 1 8 | parallel --retries 2 --sshlogin 8/localhost,8/: -j-1 "hostname; false" | wc -l
seq 1 1 | parallel --retries 2 --sshlogin 1/localhost,1/:  "hostname; false"	 | wc -l
seq 1 4 | parallel --retries 2 --sshlogin 2/localhost,2/: -j-1 "hostname; false" | wc -l
seq 1 4 | parallel --retries 2 --sshlogin 2/localhost,2/: -j1 "hostname; false"	 | wc -l
seq 1 4 | parallel --retries 2 --sshlogin 1/localhost,1/: -j1 "hostname; false"	 | wc -l
seq 1 2 | parallel --retries 2 --sshlogin 1/localhost,1/: -j1 "hostname; false"  | wc -l

