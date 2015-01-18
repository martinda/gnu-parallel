#!/bin/bash

rm -rf tmp 2>/dev/null
cp -a input-files/testdir2 tmp

NICEPAR="nice nice parallel"
export NICEPAR

cat <<'EOF' | sed -e 's/;$/; /;s/$SERVER1/'$SERVER1'/;s/$SERVER2/'$SERVER2'/' | stdout parallel -vj0 -k --joblog /tmp/jl-`basename $0` -L1
echo '### bug #42329: --line-buffer gives wrong output'; 
  $NICEPAR --line-buffer --tag seq ::: 10000000 | wc -c;
  $NICEPAR --line-buffer seq ::: 10000000 | wc -c

echo '### Test \0 as recend'; 
  printf "a\0b\0c\0" | $NICEPAR --recend   '\0' -k -N1 --pipe cat -v  \; echo; 
  printf "\0a\0b\0c" | $NICEPAR --recstart '\0' -k -N1 --pipe cat -v  \; echo

echo '### Test filenames containing UTF-8'; 
  cd tmp; 
  find . -name '*.jpg' | $NICEPAR -j +0 convert -geometry 120 {} {//}/thumb_{/}; 
  find |grep -v CVS | sort; 

echo '### bug #39554: Feature request: line buffered output'; 
  parallel -j0 --linebuffer 'echo -n start {};sleep 0.{#};echo middle -n {};sleep 1.{#}5;echo next to last {};sleep 1.{#};echo -n last {}' ::: A B C
echo

echo '### bug #39554: Feature request: line buffered output --tag'; 
  parallel --tag -j0 --linebuffer 'echo -n start {};sleep 0.{#};echo middle -n {};sleep 1.{#}5;echo next to last {};sleep 1.{#};echo -n last {}' ::: A B C
echo

echo '### test round-robin';
  nice seq 1000 | $NICEPAR --block 1k --pipe --round-robin wc | sort

echo '### bug #43600: --pipe --linebuffer --round does not work'
  seq 10000000000 | parallel --pipe --linebuffer --round cat | head

echo '### Check that 4 processes are really used'
  seq 1000000 | parallel -j4 --pipe --round --line-buf wc |sort

echo '### --version must have higher priority than retired options'
  $NICEPAR --version -g -Y -U -W -T | tail

echo '### bug #39787: --xargs broken'
  nice perl -e 'for(1..30000){print "$_\n"}' | $NICEPAR --xargs -k echo  | perl -ne 'print length $_,"\n"'

echo '### --delay should grow by 3 sec per arg'
  stdout /usr/bin/time -f %e parallel --delay 3 true ::: 1 2 | perl -ne '$_ >= 3 and $_ <= 8 and print "OK\n"'
  stdout /usr/bin/time -f %e parallel --delay 3 true ::: 1 2 3 | perl -ne '$_ >= 6 and $_ <= 11 and print "OK\n"'

echo '### Exit value should not be affected if an earlier job times out'
  $NICEPAR -j2 --timeout 1 --joblog - -k  ::: "sleep 10" "exit 255" | field 7

echo '### --header regexp'
  (echo %head1; echo %head2; seq 5) | $NICEPAR -kj2 --pipe -N2 --header '(%.*\n)*' echo JOB{#}\;cat

echo '### --header num'
  (echo %head1; echo %head2; seq 5) | $NICEPAR -kj2 --pipe -N2 --header 2 echo JOB{#}\;cat

echo '### --header regexp --round-robin'
  (echo %head1; echo %head2; seq 5) | $NICEPAR -kj2 --pipe -N2 --round --header '(%.*\n)*' echo JOB\;wc | sort

echo '### --header num --round-robin'
  (echo %head1; echo %head2; seq 5) | $NICEPAR -kj2 --pipe -N2 --round --header 2  echo JOB{#}\;wc | sort

echo '### shebang-wrap'
  $NICEPAR -k {} {} A B C ::: ./input-files/shebang/shebangwrap.*[^~]

echo 'bug #43967: Error if there exists a bin/zsh or bin/bash dir (with zsh or bash).'
  mkdir -p /tmp/bash$$/bash; PATH=/tmp/bash$$:$PATH parallel echo ::: OK; rm -rf /tmp/bash$$


EOF

rm -rf tmp
