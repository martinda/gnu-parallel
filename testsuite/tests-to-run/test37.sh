#!/bin/bash

SERVER1=redhat9.tange.dk
SERVER2=centos3.tange.dk

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
PARALLEL="-k --jobs 1 perl -pe \'\$a=1; print\$a\'" parallel -v ::: <(echo a) <(echo b)
PARALLEL='-k --jobs 1 -S parallel@'$SERVER1' perl -pe \"\\$a=1; print\\$a\"' parallel -v '<(echo {})' ::: foo

echo '### Test ugly quoting from profile file'
cat <<EOF >~/.parallel/test_profile
# testprofile
-k --jobs 1 perl -pe \'\$a=1; print \$a\'
EOF
parallel -v -J test_profile ::: <(echo a) <(echo b)

echo '### Test ugly quoting from profile file --plain'
parallel -v -J test_profile --plain echo ::: <(echo a) <(echo b)

PARALLEL='-k --jobs 1 echo' parallel -S ssh\ parallel\@$SERVER1\ ssh\ parallel@$SERVER2 -v ::: foo
PARALLEL='-k --jobs 1 perl -pe \"\\$a=1; print \\$a\"' parallel -S ssh\ parallel\@$SERVER1\ ssh\ $SERVER2 -vv '<(echo {})' ::: foo

echo '### Test quoting of $ in command from profile file'
cat <<EOF >~/.parallel/test_profile
-k --jobs 1 perl -pe \'\\\$a=1; print \\\$a\'
EOF
parallel -v -J test_profile -S ssh\ parallel\@$SERVER1\ ssh\ $SERVER2 '<(echo {})' ::: foo

echo '### Test quoting of $ in command from profile file --plain'
parallel -v -J test_profile --plain -S ssh\ parallel\@$SERVER1\ ssh\ $SERVER2 'cat <(echo {})' ::: foo

echo '### Test quoting of $ in command from $PARALLEL'
PARALLEL='-k --jobs 1 perl -pe \"\\$a=1; print \\$a\" ' parallel -S ssh\ parallel\@$SERVER1\ ssh\ $SERVER2 -v '<(echo {})' ::: foo

echo '### Test quoting of $ in command from $PARALLEL --plain'
PARALLEL='-k --jobs 1 perl -pe \"\\$a=1; print \\$a\" ' parallel --plain -S ssh\ parallel\@$SERVER1\ ssh\ $SERVER2 -v 'cat <(echo {})' ::: foo

echo '### Test quoting of space in arguments (-S) from profile file'
cat <<EOF >~/.parallel/test_profile
-k --jobs 1 -S ssh\ parallel\@$SERVER1\ ssh\ parallel@$SERVER2 perl -pe \'\$a=1; print \$a\'
EOF
parallel -v -J test_profile '<(echo {})' ::: foo

echo '### Test quoting of space in arguments (-S) from profile file --plain'
parallel -v -J test_profile --plain 'cat <(echo {})' ::: foo

echo '### Test quoting of space in arguments (-S) from $PARALLEL'
PARALLEL='-k --jobs 1 -S ssh\ parallel@'$SERVER1'\ ssh\ parallel@'$SERVER2' perl -pe \"\\$a=1; print \\$a\" ' parallel -v '<(echo {})' ::: foo

echo '### Test quoting of space in long arguments (--sshlogin) from profile file'
cat <<EOF >~/.parallel/test_profile
# testprofile
-k --jobs 1 --sshlogin ssh\ parallel\@$SERVER1\ ssh\ parallel@$SERVER2 perl -pe \'\$a=1; print \$a\'
EOF
parallel -v -J test_profile '<(echo {})' ::: foo

echo '### Test quoting of space in arguments (-S) from $PARALLEL'
PARALLEL='-k --jobs 1 --sshlogin ssh\ parallel\@'$SERVER1'\ ssh\ parallel@'$SERVER2' perl -pe \"\\$a=1; print \\$a\" ' parallel -v '<(echo {})' ::: foo

echo '### Test merging of profiles - sort needed because -k only works on the single machine'
echo --tag > ~/.parallel/test_tag
echo -S .. > ~/.parallel/test_S..
echo parallel@parallel-server1 > ~/.parallel/sshloginfile
echo parallel@parallel-server2 >> ~/.parallel/sshloginfile
parallel -Jtest_tag -Jtest_S.. --nonall echo a | sort

echo '### Test merging of profiles - sort needed because -k only works on the single machine --plain'
parallel --plain -Jtest_tag -Jtest_S.. --nonall echo a | sort
