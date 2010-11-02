#!/bin/bash

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
PARALLEL='-k --jobs 1 -S newton perl -pe "\\$a=1; print\\$a"' parallel -v ::: /etc/passwd

echo '### Test ugly quoting from profile file'
cat <<EOF >/tmp/parallel_profile
-k --jobs 1 perl -pe '\$a=1; print \$a'
EOF
parallel -v -J /tmp/parallel_profile ::: <(echo a) <(echo b)

PARALLEL='-k --jobs 1 echo' parallel -S ssh\ newton\ ssh\ maxwell -v ::: /etc/passwd
PARALLEL='-k --jobs 1 perl -pe "\\$a=1; print \\$a"' parallel -S ssh\ newton\ ssh\ maxwell -vv ::: /etc/passwd

echo '### Test quoting of $ in command from profile file'
cat <<EOF >/tmp/parallel_profile
-k --jobs 1 perl -pe '\\\$a=1; print \\\$a'
EOF
parallel -v -J /tmp/parallel_profile -S ssh\ newton\ ssh\ maxwell ::: /etc/passwd

echo '### Test quoting of $ in command from $PARALLEL'
PARALLEL='-k --jobs 1 perl -pe "\\$a=1; print \\$a" ' parallel -S ssh\ newton\ ssh\ maxwell -v ::: /etc/passwd

echo '### Test quoting of space in arguments (-S) from profile file'
cat <<EOF >/tmp/parallel_profile
-k --jobs 1 -S ssh\ newton\ ssh\ maxwell perl -pe '\$a=1; print \$a'
EOF
parallel -v -J /tmp/parallel_profile ::: /etc/passwd

echo '### Test quoting of space in arguments (-S) from $PARALLEL'
PARALLEL='-k --jobs 1 -S ssh\ newton\ ssh\ maxwell perl -pe "\\$a=1; print \\$a" ' parallel -v ::: /etc/passwd

echo '### Test quoting of space in long arguments (--sshlogin) from profile file'
cat <<EOF >/tmp/parallel_profile
-k --jobs 1 --sshlogin ssh\ newton\ ssh\ maxwell perl -pe '\$a=1; print \$a'
EOF
parallel -v -J /tmp/parallel_profile ::: /etc/passwd

echo '### Test quoting of space in arguments (-S) from $PARALLEL'
PARALLEL='-k --jobs 1 --sshlogin ssh\ newton\ ssh\ maxwell perl -pe "\\$a=1; print \\$a" ' parallel -v ::: /etc/passwd
