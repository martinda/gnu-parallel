#!/bin/bash

echo '### Test too slow spawning'
(sleep 0.3; seq 1 10 | parallel -j50 burnP6) &
seq 1 500 | nice nice stdout timeout 10 \
  parallel -j500 "killall -9 burnP6 2>/dev/null ; echo {} >/dev/null"
killall -9 burnP6
