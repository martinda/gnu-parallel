#!/bin/bash

# SSH only allowed to localhost/lo

cat <<'EOF' | sed -e s/\$SERVER1/$SERVER1/\;s/\$SERVER2/$SERVER2/ | stdout parallel -vj2 -k -L1
echo '### --hostgroup force ncpu'
  parallel --delay 0.1 --hgrp -S @g1/1/parallel@lo -S @g2/3/lo whoami\;sleep 0.{} ::: {1..8} | sort

echo '### --hostgroup two group arg'
  parallel -k --delay 0.1 --hgrp -S @g1/1/parallel@lo -S @g2/3/lo whoami\;sleep 0.{} ::: {1..8}@g1+g2 | sort

echo '### --hostgroup one group arg'
  parallel --delay 0.1 --hgrp -S @g1/1/parallel@lo -S @g2/3/lo whoami\;sleep 0.{} ::: {1..8}@g2

echo '### --hostgroup multiple group arg + unused group'
  parallel --delay 0.1 --hgrp -S @g1/1/parallel@lo -S @g1/3/lo -S @g3/100/tcsh@lo whoami\;sleep 0.{} ::: {1..8}@g1+g2 | sort

echo '### --hostgroup two groups @'
  parallel -k --hgrp -S @g1/parallel@lo -S @g2/lo --tag whoami\;echo ::: parallel@g1 tange@g2

echo '### --hostgroup'
  parallel -k --hostgroup -S @grp1/lo echo ::: no_group explicit_group@grp1 implicit_group@lo

echo '### --hostgroup --sshlogin with @'
  parallel -k --hostgroups -S parallel@lo echo ::: no_group implicit_group@parallel@lo

EOF
