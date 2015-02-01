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

EOF
