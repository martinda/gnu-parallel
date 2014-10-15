#!/bin/bash

echo "### These tests requires VirtualBox running with the following images"
echo `whoami`"@freebsd7"

VBoxManage startvm FreeBSD71 >/dev/null 2>&1
ping -c 1 freebsd7.tange.dk >/dev/null 2>&1

ssh freebsd7.tange.dk touch .parallel/will-cite
scp -q .*/src/{parallel,sem,sql,niceload} freebsd7.tange.dk:bin/

cat <<'EOF' | sed -e 's/$SERVER1/'$SERVER1'/;s/$SERVER2/'$SERVER2'/' | stdout parallel -k -S freebsd7.tange.dk -vj9 -L1
echo 'bug #40136: FreeBSD: No more processes'
  sem --jobs 3 --id my_id -u 'echo First started; sleep 5; echo The first finished' && 
  sem --jobs 3 --id my_id -u 'echo Second started; sleep 6; echo The second finished' && 
  sem --jobs 3 --id my_id -u 'echo Third started; sleep 7; echo The third finished' && 
  sem --jobs 3 --id my_id -u 'echo Fourth started; sleep 8; echo The fourth finished' && 
  sem --wait --id my_id

echo 'Test --compress --pipe'
  jot 1000 | parallel --compress --pipe cat | wc

echo 'bug #41613: --compress --line-buffer no newline';
  perl -e 'print "It worked"'| parallel --pipe --compress --line-buffer cat; echo

echo 'bug #40135: FreeBSD: sem --fg does not finish under /bin/sh'
  sem --fg 'sleep 1; echo The job finished'

echo 'bug #40133: FreeBSD: --round-robin gives no output'
  jot 1000000 | parallel --round-robin --pipe -kj3 wc | sort
  jot 1000000 | parallel --round-robin --pipe -kj4 wc | sort

echo 'bug #40134: FreeBSD: --shebang not working'
  (echo '#!/usr/bin/env -S parallel --shebang -rk echo'; echo It; echo worked) > shebang; 
  chmod 755 ./shebang; ./shebang

echo 'bug #40134: FreeBSD: --shebang(-wrap) not working'
  (echo '#!/usr/bin/env -S parallel --shebang-wrap /usr/bin/perl :::'; echo 'print @ARGV,"\n";') > shebang-wrap; 
  chmod 755 ./shebang-wrap; ./shebang-wrap wrap works

echo 'bug #40134: FreeBSD: --shebang(-wrap) with options not working'
  (echo '#!/usr/bin/env -S parallel --shebang-wrap -v -k -j 0 /usr/bin/perl -w :::'; echo 'print @ARGV,"\n";') > shebang-wrap-opt; 
  chmod 755 ./shebang-wrap-opt; ./shebang-wrap-opt wrap works with options

bash -c 'echo bug \#43358: shellshock breaks exporting functions using --env _; 
  echo Non-shellshock-hardened to non-shellshock-hardened; 
  funky() { echo Function $1; }; 
  export -f funky; 
  parallel --env funky -S localhost funky ::: non-shellshock-hardened'

bash -c 'echo bug \#43358: shellshock breaks exporting functions using --env _; 
  echo Non-shellshock-hardened to shellshock-hardened; 
  funky() { echo Function $1; }; 
  export -f funky; 
  parallel --env funky -S parallel@192.168.1.72 funky ::: shellshock-hardened'



EOF

VBoxManage controlvm FreeBSD71 savestate



