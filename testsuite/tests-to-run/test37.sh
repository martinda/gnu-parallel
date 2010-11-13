#!/bin/bash

SERVER1=parallel-server3
SERVER2=parallel-server2

echo '### Test $PARALLEL'
PARALLEL="-k
-j1
echo" parallel ::: a b c

PARALLEL="-k
--jobs
1
echo" parallel ::: a b c

PARALLEL="-k
--jobs 1
echo" parallel ::: a b c

PARALLEL="-k
--jobs
1
echo 1" parallel -v echo 2 ::: a b c

PARALLEL="-k --jobs 1 echo" parallel ::: a b c
PARALLEL="-k --jobs 1 echo 1" parallel -v echo 2 ::: a b c

echo '### Test ugly quoting from $PARALLEL'
PARALLEL="-k --jobs 1 perl -pe '\$a=1; print\$a'" parallel -v ::: <(echo a) <(echo b)
PARALLEL='-k --jobs 1 -S '$SERVER1' perl -pe "\\$a=1; print\\$a"' parallel -v ::: /bin/gunzip

echo '### Test ugly quoting from profile file'
cat <<EOF >~/.parallel/test_profile
-k --jobs 1 perl -pe '\$a=1; print \$a'
EOF
parallel -v -J test_profile ::: <(echo a) <(echo b)

PARALLEL='-k --jobs 1 echo' parallel -S ssh\ $SERVER1\ ssh\ parallel@$SERVER2 -v ::: /bin/gunzip
PARALLEL='-k --jobs 1 perl -pe "\\$a=1; print \\$a"' parallel -S ssh\ $SERVER1\ ssh\ parallel@$SERVER2 -vv ::: /bin/gunzip

echo '### Test quoting of $ in command from profile file'
cat <<EOF >~/.parallel/test_profile
-k --jobs 1 perl -pe '\\\$a=1; print \\\$a'
EOF
parallel -v -J test_profile -S ssh\ $SERVER1\ ssh\ parallel@$SERVER2 ::: /bin/gunzip

echo '### Test quoting of $ in command from $PARALLEL'
PARALLEL='-k --jobs 1 perl -pe "\\$a=1; print \\$a" ' parallel -S ssh\ $SERVER1\ ssh\ parallel@$SERVER2 -v ::: /bin/gunzip

echo '### Test quoting of space in arguments (-S) from profile file'
cat <<EOF >~/.parallel/test_profile
-k --jobs 1 -S ssh\ $SERVER1\ ssh\ parallel@$SERVER2 perl -pe '\$a=1; print \$a'
EOF
parallel -v -J test_profile ::: /bin/gunzip

echo '### Test quoting of space in arguments (-S) from $PARALLEL'
PARALLEL='-k --jobs 1 -S ssh\ '$SERVER1'\ ssh\ parallel@'$SERVER2' perl -pe "\\$a=1; print \\$a" ' parallel -v ::: /bin/gunzip

echo '### Test quoting of space in long arguments (--sshlogin) from profile file'
cat <<EOF >~/.parallel/test_profile
-k --jobs 1 --sshlogin ssh\ $SERVER1\ ssh\ parallel@$SERVER2 perl -pe '\$a=1; print \$a'
EOF
parallel -v -J test_profile ::: /bin/gunzip

echo '### Test quoting of space in arguments (-S) from $PARALLEL'
PARALLEL='-k --jobs 1 --sshlogin ssh\ '$SERVER1'\ ssh\ parallel@'$SERVER2' perl -pe "\\$a=1; print \\$a" ' parallel -v ::: /bin/gunzip
