#!/bin/bash

echo '### Test --number-of-cpus'
parallel --number-of-cpus

echo '### Test --number-of-cores'
parallel --number-of-cores

echo '### Test --use-cpus-instead-of-cores'
(seq 1 4 | stdout parallel --use-cpus-instead-of-cores -j100% sleep) && echo CPUs done &
(seq 1 4 | stdout parallel -j100% sleep) && echo cores done &
echo 'Cores should complete first on machines with less than 4 physical CPUs'
wait


