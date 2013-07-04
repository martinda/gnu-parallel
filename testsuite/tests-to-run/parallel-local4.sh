#!/bin/bash

cat <<'EOF' | parallel -j0 -vk
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
  seq 100 | parallel --joblog - --pipe wc 

EOF
