#!/bin/bash

cat <<'EOF' | sed -e 's/;$/; /;s/$SERVER1/'$SERVER1'/;s/$SERVER2/'$SERVER2'/' | stdout parallel -vj0 -k -L1
echo '### Test of xargs -m command lines > 130k'; 
  seq 1 60000 | parallel -m -j1 echo a{}b{}c | tee >(wc >/tmp/awc$$) >(sort | md5sum) >/tmp/a$$; 
  wait; 
  CHAR=$(cat /tmp/a$$ | wc -c); 
  LINES=$(cat /tmp/a$$ | wc -l); 
  echo "Chars per line:" $(echo "$CHAR/$LINES" | bc); 
  cat /tmp/awc$$; 
  rm /tmp/a$$ /tmp/awc$$

echo '### Test of xargs -X command lines > 130k'; 
  seq 1 60000 | parallel -X -j1 echo a{}b{}c | tee >(wc >/tmp/bwc$$) >(sort | (sleep 1; md5sum)) >/tmp/b$$; 
  wait; 
  CHAR=$(cat /tmp/b$$ | wc -c); 
  LINES=$(cat /tmp/b$$ | wc -l); 
  echo "Chars per line:" $(echo "$CHAR/$LINES" | bc); 
  cat /tmp/bwc$$; 
  rm /tmp/b$$ /tmp/bwc$$

echo '### Test of xargs -m command lines > 130k'; 
  seq 1 60000 | parallel -k -j1 -m echo | md5sum

echo '### This causes problems if we kill child processes'; 
  seq 2 40 | parallel -j 0 seq 1 10  | sort | md5sum

echo '### This causes problems if we kill child processes (II)'; 
  seq 1 40 | parallel -j 0 seq 1 10 '| parallel -j 3 echo' | sort | md5sum

echo '### Test -m'; 
  (echo foo;echo bar) | parallel -j1 -m echo 1{}2{}3 A{}B{}C

echo '### Test -X'; 
  (echo foo;echo bar) | parallel -j1 -X echo 1{}2{}3 A{}B{}C

echo '### Bug before 2009-08-26 causing regexp compile error or infinite loop'; 
  echo a | parallel -qX echo  "'"{}"' "

echo '### Bug before 2009-08-26 causing regexp compile error or infinite loop (II)'; 
  echo a | parallel -qX echo  "'{}'"

echo '### bug #42041: Implement $PARALLEL_JOBSLOT'
  parallel -k --slotreplace // -j2 sleep 1\;echo // ::: {1..4}
  parallel -k -j2 sleep 1\;echo {%} ::: {1..4}

echo '### bug #42363: --pipepart and --fifo/--cat does not work'
  seq 100 > /tmp/bug42363; 
  parallel --pipepart --block 31 -a /tmp/bug42363 -k --fifo wc | perl -pe s:/tmp/.........pip:/tmp/XXXX: ; 
  parallel --pipepart --block 31 -a /tmp/bug42363 -k --cat  wc | perl -pe s:/tmp/.........pip:/tmp/XXXX: ;

echo '### bug #42055: --pipe -a bigfile should not require sequential reading of bigfile'
  parallel --pipepart -a /etc/passwd -L 1 should not be run
  parallel --pipepart -a /etc/passwd -N 1 should not be run
  parallel --pipepart -a /etc/passwd -l 1 should not be run

echo '### bug #42893: --block should not cause decimals in cat_partial'
  seq 100000 >/tmp/parallel-decimal; 
  parallel --dry-run -kvv --pipepart --block 0.12345M -a /tmp/parallel-decimal true; 
  rm /tmp/parallel-decimal

echo '### bug #42902: profiles containing arguments with space'
  echo "--rpl 'FULLPATH chomp(\$_=\"/bin/bash=\".\`readlink -f \$_\`);' " > ~/.parallel/FULLPATH; 
  parallel -JFULLPATH echo FULLPATH ::: $0

echo '### bug #42892: parallel -a nonexiting --pipepart'
  parallel --pipepart -a nonexisting wc

echo '### bug #42913: Dont use $SHELL but the shell currently running'
  echo '## Unknown shell => $SHELL (bash)'
  parallel -j1 "cp \`which {}\` /tmp/SHELL; /tmp/SHELL -c 'parallel -Dinit echo ::: 1' | grep which;" 
  ::: ash bash csh dash fdsh fish fizsh ksh ksh93 mksh pdksh posh rbash rush rzsh sash sh static-sh tcsh yash zsh
  echo '## Known shells -c'
  parallel -k "\`which {}\` -c 'parallel -Dinit echo ::: 1' | grep which;" 
  ::: ash bash csh dash fdsh fish fizsh ksh ksh93 mksh pdksh posh rbash rush rzsh sash sh static-sh tcsh yash zsh
  echo '## Known shells |'
  parallel -k "echo 'parallel -Dinit echo ::: 1' | \`which {}\` | grep which;" 
  ::: ash bash csh dash fdsh fish fizsh ksh ksh93 mksh pdksh posh rbash rush rzsh sash sh static-sh tcsh yash zsh
  echo '## Started directly from perl'
  perl -e 'system(qw(parallel -Dinit echo ::: 1))' | grep which

EOF

# TODO This is too unstable
# echo '### --tmux test - check termination'
#  perl -e 'map {printf "$_%o%c\n",$_,$_}1..255' | stdout parallel --tmux echo {} :::: - ::: a b | perl -pe 's/\d/0/g'
