#!/bin/bash

# -L1 will join lines ending in ' '
cat <<'EOF' | sed -e 's/;$/; /;s/$SERVER1/'$SERVER1'/;s/$SERVER2/'$SERVER2'/' | stdout parallel -vj0 -k --joblog /tmp/jl-`basename $0` -L1
echo '### Test mutex. This should not mix output'; 
  parallel --semaphore --id mutex -u seq 1 10 '|' pv -qL 20; 
  parallel --semaphore --id mutex -u seq 11 20 '|' pv -qL 100; 
  parallel --semaphore --id mutex --wait; 
  echo done

echo '### Test semaphore 2 jobs running simultaneously'
  parallel --semaphore --id 2jobs -u -j2 'echo job1a 1; sleep 1; echo job1b 3'; 
  sleep 0.2; 
  parallel --semaphore --id 2jobs -u -j2 'echo job2a 2; sleep 1; echo job2b 5'; 
  sleep 0.2; 
  parallel --semaphore --id 2jobs -u -j2 'echo job3a 4; sleep 1; echo job3b 6'; 
  parallel --semaphore --id 2jobs --wait; 
  echo done

echo '### Test if parallel invoked as sem will run parallel --semaphore'
  sem --id as_sem -u -j2 'echo job1a 1; sleep 1; echo job1b 3'; 
  sleep 0.2; 
  sem --id as_sem -u -j2 'echo job2a 2; sleep 1; echo job2b 5'; 
  sleep 0.2; 
  sem --id as_sem -u -j2 'echo job3a 4; sleep 1; echo job3b 6'; 
  sem --id as_sem --wait; 
  echo done

echo '### Test similar example as from man page - run 2 jobs simultaneously'
echo 'Expect done: 1 2 5 3 4'
for i in 5 1 2 3 4 ; do 
  sleep 0.2; 
  echo Scheduling $i; 
  sem -j2 --id ex2jobs -u echo starting $i ";" sleep $i ";" echo done $i; 
done; 
sem --id ex2jobs --wait

echo '### Test --fg followed by --bg'
  parallel -u --id fgbg --fg --semaphore seq 1 10 '|' pv -qL 30; 
  parallel -u --id fgbg --bg --semaphore seq 11 20 '|' pv -qL 30; 
  parallel -u --id fgbg --fg --semaphore seq 21 30 '|' pv -qL 30; 
  parallel -u --id fgbg --bg --semaphore seq 31 40 '|' pv -qL 30; 
  sem --id fgbg --wait

echo '### Test bug #33621: --bg -p should give an error message'
  stdout parallel -p --bg echo x{}

echo '### Failed on 20141226'
  sem --fg --line-buffer --id bugin20141226 echo OK

echo '### Test --st +1/-1'
  stdout sem --id st --line-buffer "echo A normal-start;sleep 3;echo C normal-end"; 
  stdout sem --id st --line-buffer --st 1 "echo B st1-start;sleep 3;echo D st1-end"; 
  stdout sem --id st --line-buffer --st -1 "echo ERROR-st-1-start;sleep 3;echo ERROR-st-1-end"; 
  stdout sem --id st --wait


EOF