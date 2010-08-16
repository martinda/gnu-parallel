#!/bin/bash

echo '### Test mutex. This should not mix output'
parallel -u --semaphore seq 1 10 '|' pv -qL 20
parallel -u --semaphore seq 11 20 '|' pv -qL 100
parallel --semaphore --wait
echo done

echo '### Test default id = --id `tty`'
parallel --id `tty` -u --semaphore seq 1 10 '|' pv -qL 20
parallel -u --semaphore seq 11 20 '|' pv -qL 100
parallel --id `tty` --semaphore --wait
echo done

echo '### Test semaphore 2 jobs running simultaneously'
parallel -u -j2 --semaphore 'echo job1; sleep 0.5; echo job1'
parallel -u -j2 --semaphore 'echo job2; sleep 0.5; echo job2'
parallel --semaphore --wait
echo done

echo '### Test if parallel invoked as sem will run parallel --semaphore'
sem -u -j2 'echo job1; sleep 0.5; echo job1'
sem -u -j2  'echo job2; sleep 0.5; echo job2'
sem --wait
echo done

echo '### Test similar example as from man page'
for i in 0.5 0.1 0.2 0.3 0.4 ; do
  echo $i
  sem -j+0 sleep $i ";" echo done $i
done
sem --wait
