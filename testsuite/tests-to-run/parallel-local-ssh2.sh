#!/bin/bash

cat <<'EOF' | sed -e s/\$SERVER1/$SERVER1/\;s/\$SERVER2/$SERVER2/ | stdout parallel -vj6 -k --joblog /tmp/jl-`basename $0` -L1
echo "### bug #43518: GNU Parallel doesn't obey servers' jobs capacity when an ssh login file is reloaded"
  # Pre-20141106 Would reset the number of jobs run on all sshlogin if --slf changed
  # Thus must take at least 25 sec to run
  echo -e '1/lo\n1/csh@lo\n1/tcsh@lo\n1/parallel@lo\n' > /tmp/parallel.bug43518; 
  parallel --delay 0.1 -N0 echo 1/: '>>' /tmp/parallel.bug43518 ::: {1..100} & 
  seq 30 | stdout /usr/bin/time -f %e parallel  --slf /tmp/parallel.bug43518 'sleep {=$_=$_%3?0:10=}.{%}' | 
  perl -ne '$_ > 25 and print "OK\n"'

echo '### --filter-hosts --slf <()'
  parallel --nonall --filter-hosts --slf <(echo localhost) echo OK

echo '### --wd no-such-dir - csh'
  stdout parallel --wd /no-such-dir -S csh@localhost echo ::: "ERROR IF PRINTED"; echo Exit code $?
echo '### --wd no-such-dir - tcsh'
  stdout parallel --wd /no-such-dir -S tcsh@localhost echo ::: "ERROR IF PRINTED"; echo Exit code $?
echo '### --wd no-such-dir - bash'
  stdout parallel --wd /no-such-dir -S parallel@localhost echo ::: "ERROR IF PRINTED"; echo Exit code $?

echo '### bug #42725: csh with \n in variables'
  not_csh() { echo This is not csh/tcsh; }; 
  export -f not_csh; 
  parallel --env not_csh -S csh@lo not_csh ::: 1; 
  parallel --env not_csh -S tcsh@lo not_csh ::: 1; 
  parallel --env not_csh -S parallel@lo not_csh ::: 1

echo '### bug #43358: shellshock breaks exporting functions using --env'
  echo shellshock-hardened to shellshock-hardened; 
  funky() { echo Function $1; }; 
  export -f funky; 
  parallel --env funky -S parallel@localhost funky ::: shellshock-hardened

echo '2bug #43358: shellshock breaks exporting functions using --env'
  echo shellshock-hardened to non-shellshock-hardened; 
  funky() { echo Function $1; }; 
  export -f funky; 
  parallel --env funky -S centos3.tange.dk funky ::: non-shellshock-hardened

echo '### bug #42999: --pipepart with remote does not work'
  seq 100 > /tmp/bug42999; chmod 600 /tmp/bug42999; 
  parallel --sshdelay 0.3 --pipepart --block 31 -a /tmp/bug42999 -k -S parallel@lo wc | perl -pe s:/tmp/.........pip:/tmp/XXXX: ; 
  parallel --sshdelay 0.2 --pipepart --block 31 -a /tmp/bug42999 -k --fifo -S parallel@lo wc | perl -pe s:/tmp/.........pip:/tmp/XXXX: ; 
  parallel --sshdelay 0.1 --pipepart --block 31 -a /tmp/bug42999 -k --cat -S parallel@lo wc | perl -pe s:/tmp/.........pip:/tmp/XXXX: ;

echo '### --cat gives incorrect exit value in csh'
  echo false | parallel --pipe --cat   -Scsh@lo 'cat {}; false' ; echo $?; 
  echo false | parallel --pipe --cat  -Stcsh@lo 'cat {}; false' ; echo $?; 
  echo true  | parallel --pipe --cat   -Scsh@lo 'cat {}; true' ; echo $?; 
  echo true  | parallel --pipe --cat  -Stcsh@lo 'cat {}; true' ; echo $?; 

echo '### --cat and --fifo exit value in bash'
  echo true  | parallel --pipe --fifo -Slo 'cat {}; true' ; echo $?; 
  echo false | parallel --pipe --fifo -Slo 'cat {}; false' ; echo $?; 

EOF
