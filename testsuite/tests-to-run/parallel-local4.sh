#!/bin/bash

cat <<'EOF' | sed -e 's/;$/; /;s/$SERVER1/'$SERVER1'/;s/$SERVER2/'$SERVER2'/' | stdout parallel -vj0 -k --joblog /tmp/jl-`basename $0` -L1
echo '### bug #36595: silent loss of input with --pipe and --sshlogin'
  seq 10000 | xargs | parallel --pipe -S 10/localhost cat | wc

echo 'bug #36707: --controlmaster eats jobs'
  seq 2 | parallel -k --controlmaster --sshlogin localhost echo OK{}

echo '### -L -n with pipe'
  seq 14 | parallel --pipe -k -L 3 -n 2 'cat;echo 6 Ln line record'

echo '### -L -N with pipe'
  seq 14 | parallel --pipe -k -L 3 -N 2 'cat;echo 6 LN line record'

echo '### -l -N with pipe'
  seq 14 | parallel --pipe -k -l 3 -N 2 'cat;echo 6 lN line record'

echo '### -l -n with pipe'
  seq 14 | parallel --pipe -k -l 3 -n 2 'cat;echo 6 ln line record'

echo '### bug #39360: --joblog does not work with --pipe'
  seq 100 | parallel --joblog - --pipe wc | tr '0-9' 'X'

echo '### bug #39572: --tty and --joblog do not work'
  seq 1 | parallel --joblog - -u true | tr '0-9' 'X'

echo '### How do we deal with missing $HOME'
   unset HOME; stdout perl -w $(which parallel) -k echo ::: 1 2 3

echo '### How do we deal with missing $SHELL'
   unset SHELL; stdout perl -w $(which parallel) -k echo ::: 1 2 3

echo '### Test if length is computed correctly - first should give one line, second 2 lines each'
  seq 4 | parallel -s 29 -X -kj1 echo a{}b{}c
  seq 4 | parallel -s 28 -X -kj1 echo a{}b{}c
  seq 4 | parallel -s 21 -X -kj1 echo {} {}
  seq 4 | parallel -s 20 -X -kj1 echo {} {}
  seq 4 | parallel -s 23 -m -kj1 echo a{}b{}c
  seq 4 | parallel -s 22 -m -kj1 echo a{}b{}c
  seq 4 | parallel -s 21 -m -kj1 echo {} {}
  seq 4 | parallel -s 20 -m -kj1 echo {} {}

echo 'bug #44144: --tagstring {=s/a/b/=} broken'
  # Do not be confused by {} in --rpl
  parallel --rpl '{:} s/A/D/;{}' --tagstring '{1:}{-1:}{= s/A/E/=}' echo {} ::: A/B.C
  # Non-standard --parens 
  parallel --parens ,, --rpl '{:} s/A/D/;{}' --tagstring '{1:}{-1:}, 's/A/E/, echo {} ::: A/B.C
  # Non-standard --parens -i
  parallel --rpl '{:} s/A/D/;{}' --tag --parens ,, -iDUMMY echo {} ::: A/B.C

echo 'env in zsh'
  echo 'Normal variable export'
  export B=\'; 
  PARALLEL_SHELL=/usr/bin/zsh parallel --env B echo '$B' ::: a

  echo 'Function export as variable'
  export myfuncvar="() { echo myfuncvar \$*; }"; 
  PARALLEL_SHELL=/usr/bin/zsh parallel --env myfuncvar myfuncvar ::: a

  echo 'Function export as function'
  myfunc() { echo myfunc $*; };
  export -f myfunc; 
  PARALLEL_SHELL=/usr/bin/zsh parallel --env myfunc myfunc ::: a

EOF
