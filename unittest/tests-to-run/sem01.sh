#!/bin/bash

echo '### Test mutex. This should not mix output'
parallel -u --semaphore seq 1 10 '|' pv -qL 20
parallel -u --semaphore seq 11 20 '|' pv -qL 100
parallel --semaphore --wait
echo done

echo '### Test default id = --id `tty` and --semaphorename'
parallel --id `tty` -u --semaphore seq 1 10 '|' pv -qL 20
parallel -u --semaphore seq 11 20 '|' pv -qL 100
parallel --semaphorename `tty` --semaphore --wait
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

echo '### Test similar example as from man page - run 2 jobs simultaneously'
echo 'Expect done: 1 2 5 3 4'
for i in 5 1 2 3 4 ; do
  echo Scheduling $i
  sem -j2 -u echo starting $i ";" sleep $i ";" echo done $i
done
sem --wait

echo '### Test --fg followed by --bg'
parallel -u --fg --semaphore seq 1 10 '|' pv -qL 30
parallel -u --bg --semaphore seq 11 20 '|' pv -qL 30
parallel -u --fg --semaphore seq 21 30 '|' pv -qL 30
parallel -u --bg --semaphore seq 31 40 '|' pv -qL 30
sem --wait
