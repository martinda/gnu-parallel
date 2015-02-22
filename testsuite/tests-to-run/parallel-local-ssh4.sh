#!/bin/bash

# SSH only allowed to localhost/lo
cat <<'EOF' | sed -e s/\$SERVER1/$SERVER1/\;s/\$SERVER2/$SERVER2/ | parallel -vj8 -k --joblog /tmp/jl-`basename $0` -L1
echo '### zsh'
  ssh zsh@lo 'fun="() { echo function from zsh to zsh \$*; }"; 
              export fun; 
              parallel --env fun fun ::: OK'

  ssh zsh@lo 'fun="() { echo function from zsh to bash \$*; }"; 
              export fun; 
              parallel -S parallel@lo --env fun fun ::: OK'

echo '### csh'
  echo "3 big vars run remotely - length(base64) > 1000"
  ssh csh@lo 'setenv A `seq 200|xargs`; 
              setenv B `seq 200 -1 1|xargs`; 
              setenv C `seq 300 -2 1|xargs`; 
              parallel -Scsh@lo --env A,B,C -k echo \$\{\}\|wc ::: A B C'

  echo "3 big vars run locally"
  ssh csh@lo 'setenv A `seq 200|xargs`; 
              setenv B `seq 200 -1 1|xargs`; 
              setenv C `seq 300 -2 1|xargs`; 
              parallel --env A,B,C -k echo \$\{\}\|wc ::: A B C'

echo '### Test tmux works on different shells'
  parallel -Scsh@lo,tcsh@lo,parallel@lo,zsh@lo --tmux echo ::: 1 2 3 4; echo $?
  parallel -Scsh@lo,tcsh@lo,parallel@lo,zsh@lo --tmux false ::: 1 2 3 4; echo $?

  export PARTMUX='parallel -Scsh@lo,tcsh@lo,parallel@lo,zsh@lo --tmux '; 
  ssh zsh@lo "$PARTMUX" 'true ::: 1 2 3 4; echo $status'; 
  ssh zsh@lo "$PARTMUX" 'false ::: 1 2 3 4; echo $status'; 
  ssh parallel@lo "$PARTMUX" 'true ::: 1 2 3 4; echo $?'; 
  ssh parallel@lo "$PARTMUX" 'false ::: 1 2 3 4; echo $?'; 
  ssh tcsh@lo "$PARTMUX" 'true ::: 1 2 3 4; echo $status'; 
  ssh tcsh@lo "$PARTMUX" 'false ::: 1 2 3 4; echo $status'

echo '### TODO This fails - word too long'
  export PARTMUX='parallel -Scsh@lo,tcsh@lo,parallel@lo,zsh@lo --tmux '; 
  stdout ssh csh@lo "$PARTMUX" 'true ::: 1 2 3 4; echo $status' | grep -v 'See output'; 
  stdout ssh csh@lo "$PARTMUX" 'false ::: 1 2 3 4; echo $status' | grep -v 'See output'

echo '### works'
  parallel -Sparallel@lo --tmux echo ::: \\\\\\\"\\\\\\\"\\\;\@
  stdout parallel -Sparallel@lo --tmux echo ::: xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

echo '### These blocked due to length'
  parallel -Slo --tmux echo ::: \\\\\\\"\\\\\\\"\\\;\@
  parallel -Scsh@lo --tmux echo ::: \\\\\\\"\\\\\\\"\\\;\@
  parallel -Stcsh@lo --tmux echo ::: \\\\\\\"\\\\\\\"\\\;\@
  parallel -Szsh@lo --tmux echo ::: \\\\\\\"\\\\\\\"\\\;\@
  parallel -Scsh@lo --tmux echo ::: 111111111111111111111111111111111111111111111111111111111



EOF
