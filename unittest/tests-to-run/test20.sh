#!/bin/bash

PAR=parallel

echo '### Test --number-of-cpus'
$PAR --number-of-cpus

echo '### Test --number-of-cores'
$PAR --number-of-cores

echo '### Test --use-cpus-instead-of-cores'
(seq 1 4 | $PAR --use-cpus-instead-of-cores -j100% sleep) && echo CPUs done &
(seq 1 4 | $PAR -j100% sleep) && echo cores done &
echo 'Cores should complete first on machines with less than 4 physical CPUs'
wait


