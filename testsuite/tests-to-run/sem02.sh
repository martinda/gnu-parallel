#!/bin/bash

echo '### Test id = --id `tty`'
parallel --id `tty` -u --semaphore seq 1 10 '|' pv -qL 20
echo '### Test default id = --id `tty`'
parallel -u --semaphore seq 11 20 '|' pv -qL 100
echo '### Test --semaphorename `tty`'
parallel --semaphorename `tty` --semaphore --wait
echo done
