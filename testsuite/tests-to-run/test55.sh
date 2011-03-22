#!/bin/bash

echo '### Test race condition on 8 CPU (my laptop)'
seq 1 5000000 > /tmp/parallel_test
seq 1 10 | parallel -k "cat /tmp/parallel_test | parallel --pipe --recend '' -k gzip >/dev/null; echo {}"

