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

seq 1 10 | src/parallel --recend "\n" -j1 --spreadstdin gzip -9 >/tmp/foo.gz

echo '### Test --spreadstdin - similar to the failing below'
seq 1 100000 | parallel --recend "\n" -j10 --spreadstdin gzip -9 >/tmp/foo.gz
diff <(seq 1 100000) <(zcat /tmp/foo.gz |sort -n)
diff <(seq 1 100000|wc -c) <(zcat /tmp/foo.gz |wc -c)

echo '### Test --spreadstdin - this failed during devel'
seq 1 1000000 | md5sum
# Should give same result when sorted
seq 1 1000000 | parallel --recend "\n" -j10 --spreadstdin gzip -9 | zcat | sort -n | md5sum

echo '### Test --spreadstdin -k'
seq 1 1000000 | parallel -k --recend "\n" -j10 --spreadstdin gzip -9 | zcat | md5sum

echo '### Test --spreadstdin --files'
seq 1 1000000 | shuf | parallel --files --recend "\n" -j10 --spreadstdin sort | parallel -X sort -m | md5sum
