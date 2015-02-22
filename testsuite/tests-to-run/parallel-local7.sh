#!/bin/bash

par_tmux_filter() {
    perl -pe 's/par......tms/parXXXXX.tms/;s/ p\d+/pID/;'
}
export -f par_tmux_filter

par_tmux() {
    (stdout parallel --timeout 3 --tmux --delay .3 echo '{}{=$_="\\"x$_=}'; echo $?) | par_tmux_filter
}
export -f par_tmux

cat <<'EOF' | sed -e 's/;$/; /;s/$SERVER1/'$SERVER1'/;s/$SERVER2/'$SERVER2'/' | stdout parallel -vj8 --retries 2 -k --joblog /tmp/jl-`basename $0` -L1
echo '### tmux1.9'
  seq 000 100 | TMUX=tmux1.9 par_tmux
  seq 100 200 | TMUX=tmux1.9 par_tmux
  seq 200 300 | TMUX=tmux1.9 par_tmux
  seq 300 400 | TMUX=tmux1.9 par_tmux
  seq 400 500 | TMUX=tmux1.9 par_tmux
  seq 500 600 | TMUX=tmux1.9 par_tmux
  seq 600 700 | TMUX=tmux1.9 par_tmux
  seq 700 800 | TMUX=tmux1.9 par_tmux
  seq 800 900 | TMUX=tmux1.9 par_tmux
  seq 900 1000 | TMUX=tmux1.9 par_tmux
  seq 1000 1100 | TMUX=tmux1.9 par_tmux
  seq 1100 1200 | TMUX=tmux1.9 par_tmux
  seq 1200 1300 | TMUX=tmux1.9 par_tmux
  seq 1300 1400 | TMUX=tmux1.9 par_tmux
  seq 1400 1500 | TMUX=tmux1.9 par_tmux
  seq 1500 1600 | TMUX=tmux1.9 par_tmux
  seq 1600 1700 | TMUX=tmux1.9 par_tmux
  seq 1700 1800 | TMUX=tmux1.9 par_tmux
  seq 1800 1900 | TMUX=tmux1.9 par_tmux
  seq 1900 2000 | TMUX=tmux1.9 par_tmux
  seq 2000 2021 | TMUX=tmux1.9 par_tmux
echo '### tmux1.9 fails'
  echo 2022 | TMUX=tmux1.9 par_tmux

echo '### tmux1.8'
  seq 1 50 | TMUX=tmux1.8 par_tmux
  seq 51 100 | TMUX=tmux1.8 par_tmux
  seq 101 150 | TMUX=tmux1.8 par_tmux
  seq 151 200 | TMUX=tmux1.8 par_tmux
  seq 201 233 | TMUX=tmux1.8 par_tmux
echo '### tmux1.8 fails'
  echo 234 | TMUX=tmux1.8 par_tmux
  echo 235 | TMUX=tmux1.8 par_tmux
  echo 236 | TMUX=tmux1.8 par_tmux

echo '### tmux1.8 0..255 ascii'
perl -e 'print map { ($_, map { pack("c*",$_) } grep { $_>=1 && $_!=10 } 0..$_),"\n" } 0..255' | 
   TMUX=tmux1.8 stdout parallel --tmux --timeout 3 echo | par_tmux_filter; echo $?

echo '### tmux1.9 0..255 ascii'
perl -e 'print map { ($_, map { pack("c*",$_) } grep { $_>=1 && $_!=10 } 0..$_),"\n" } 0..255' | 
   TMUX=tmux1.9 stdout parallel --tmux --timeout 3 echo | par_tmux_filter; echo $?

echo '### Test output ascii'
  rm -f /tmp/paralocal7*; 
  perl -e 'print map { ($_, map { pack("c*",$_) } grep { $_!=10 } 1..$_),"\n" } 1..255' | stdout parallel --tmux echo {}'>>/tmp/paralocal7{%}' | par_tmux_filter; 
  sort /tmp/paralocal7* | md5sum

echo '### Test critical lengths. Must not block'
  seq 70 130  | TMUX=tmux1.8 stdout parallel --tmux echo '{}{=$_="&"x$_=}' | par_tmux_filter
  seq 70 130  | TMUX=tmux1.9 stdout parallel --tmux echo '{}{=$_="&"x$_=}' | par_tmux_filter
  seq 280 425 | TMUX=tmux1.8 stdout parallel --tmux echo '{}{=$_="a"x$_=}' | par_tmux_filter
  seq 280 425 | TMUX=tmux1.9 stdout parallel --tmux echo '{}{=$_="a"x$_=}' | par_tmux_filter

EOF
