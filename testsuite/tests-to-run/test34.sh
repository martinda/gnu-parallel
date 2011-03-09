#!/bin/bash

echo '### Test too slow spawning'
seq 1000000000 1000000010 | pv -L 10 -q | stdout parallel -j 10 echo
