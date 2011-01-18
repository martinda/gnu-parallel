#!/bin/bash

echo '### Test --spreadstdin - more procs than args'
rm /tmp/parallel.ss.*
seq 1 5 | stdout parallel -j 10 --spreadstdin 'cat >/tmp/parallel.ss.$PARALLEL_SEQ' >/dev/null
cat /tmp/parallel.ss.*

echo '### Test --spreadstdin - more args than procs'
rm /tmp/parallel.ss.*
seq 1 10 | stdout parallel -j 5 --spreadstdin 'cat >/tmp/parallel.ss.$PARALLEL_SEQ' >/dev/null
cat /tmp/parallel.ss.*

seq 1 1000| parallel -j1 --spreadstdin cat "|cat "|wc -c
seq 1 10000| parallel -j10 --spreadstdin cat "|cat "|wc -c
seq 1 100000| parallel -j1 --spreadstdin cat "|cat "|wc -c
seq 1 1000000| parallel -j10 --spreadstdin cat "|cat "|wc -c
