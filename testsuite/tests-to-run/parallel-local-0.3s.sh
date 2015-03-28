#!/bin/bash

# Simple jobs that never fails
# Each should be taking 0.3-1s and be possible to run in parallel
# I.e.: No race conditions, no logins
cat <<'EOF' | sed -e 's/;$/; /;s/$SERVER1/'$SERVER1'/;s/$SERVER2/'$SERVER2'/' | stdout parallel -vj0 -k --joblog /tmp/jl-`basename $0` -L1
echo '### Test exit val - true'; 
  echo true | parallel; 
  echo $?

echo '**'

echo '### Test exit val - false'; 
  echo false | parallel; 
  echo $?

echo '**'

echo '### Test bug #43284: {%} and {#} with --xapply'; 
  parallel --xapply 'echo {1} {#} {%} {2}' ::: a ::: b; 
  parallel -N2 'echo {%}' ::: a b

echo '**'

echo '### Test bug #43376: {%} and {#} with --pipe'
  echo foo | parallel -q --pipe -k echo {#}
  echo foo | parallel --pipe -k echo {%}
  echo foo | parallel -q --pipe -k echo {%}
  echo foo | parallel --pipe -k echo {#}

echo '**'

echo '### {= and =} in different groups separated by space'
  parallel echo {= s/a/b/ =} ::: a
  parallel echo {= s/a/b/=} ::: a
  parallel echo {= s/a/b/=}{= s/a/b/=} ::: a
  parallel echo {= s/a/b/=}{=s/a/b/=} ::: a
  parallel echo {= s/a/b/=}{= {= s/a/b/=} ::: a
  parallel echo {= s/a/b/=}{={=s/a/b/=} ::: a
  parallel echo {= s/a/b/ =} {={==} ::: a
  parallel echo {={= =} ::: a
  parallel echo {= {= =} ::: a
  parallel echo {= {= =} =} ::: a

echo '**'

echo '### {} as part of the command'
  echo p /bin/ls | parallel l{= s/p/s/ =}
  echo /bin/ls-p | parallel --colsep '-' l{=2 s/p/s/ =} {1}
  echo s /bin/ls | parallel l{}
  echo /bin/ls | parallel ls {}
  echo ls /bin/ls | parallel {}
  echo ls /bin/ls | parallel

echo '**'

echo '### bug #43817: Some JP char cause problems in positional replacement strings'
  parallel -k echo ::: '�<�>' '�<1 $_=2�>' 'ワ'
  parallel -k echo {1} ::: '�<�>' '�<1 $_=2�>' 'ワ'
  parallel -Xj1 echo ::: '�<�>' '�<1 $_=2�>' 'ワ'
  parallel -Xj1 echo {1} ::: '�<�>' '�<1 $_=2�>' 'ワ'

echo '**'

echo '### --rpl % that is a substring of longer --rpl %D'
parallel --plus --rpl '%' 
  --rpl '%D $_=::shell_quote(::dirname($_));' --rpl '%B s:.*/::;s:\.[^/.]+$::;' --rpl '%E s:.*\.::' 
  'echo {}=%;echo %D={//};echo %B={/.};echo %E={+.};echo %D/%B.%E={}' ::: a.b/c.d/e.f

echo '**'

echo '### Disk full'
cat /dev/zero >/mnt/ram/out; 
  parallel --tmpdir /mnt/ram echo ::: OK; 
  rm /mnt/ram/out

echo '**'

echo '### bug #44546: If --compress-program fails: fail'
  parallel --line-buffer --compress-program false echo \;ls ::: /no-existing; echo $?
  parallel --tag --line-buffer --compress-program false echo \;ls ::: /no-existing; echo $?
  (parallel --files --tag --line-buffer --compress-program false echo \;sleep 1\;ls ::: /no-existing; echo $?) | tail -n1
  parallel --tag --compress-program false echo \;ls ::: /no-existing; echo $?
  parallel --line-buffer --compress-program false echo \;ls ::: /no-existing; echo $?
  parallel --compress-program false echo \;ls ::: /no-existing; echo $?

echo '### bug #44614: --pipepart --header off by one'
  seq 10 >/tmp/parallel_44616; 
    parallel --pipepart -a /tmp/parallel_44616 -k --block 5 'echo foo; cat'; 
    parallel --pipepart -a /tmp/parallel_44616 -k --block 2 --regexp --recend 3'\n' 'echo foo; cat'; 
    rm /tmp/parallel_44616

echo '### TMUX not found'
  TMUX=not-existing parallel --tmux echo ::: 1

EOF
