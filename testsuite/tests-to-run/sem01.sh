#!/bin/bash

echo '### Test mutex. This should not mix output'
parallel -u --semaphore seq 1 10 '|' pv -qL 20
parallel -u --semaphore seq 11 20 '|' pv -qL 100
parallel --semaphore --wait
echo done

echo '### Test semaphore 2 jobs running simultaneously'
parallel -u -j2 --semaphore 'echo job1a 1; sleep 1; echo job1b 3'
sleep 0.2
parallel -u -j2 --semaphore 'echo job2a 2; sleep 1; echo job2b 5'
sleep 0.2
parallel -u -j2 --semaphore 'echo job3a 4; sleep 1; echo job3b 6'
parallel --semaphore --wait
echo done

echo '### Test if parallel invoked as sem will run parallel --semaphore'
sem -u -j2 'echo job1a 1; sleep 1; echo job1b 3'
sleep 0.2
sem -u -j2 'echo job2a 2; sleep 1; echo job2b 5'
sleep 0.2
sem -u -j2 'echo job3a 4; sleep 1; echo job3b 6'
sem --wait
echo done

echo '### Test similar example as from man page - run 2 jobs simultaneously'
echo 'Expect done: 1 2 5 3 4'
for i in 5 1 2 3 4 ; do
  sleep 0.2
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

echo '### Test bug #33621: --bg -p should give an error message'
stdout parallel -p --bg echo x{}
