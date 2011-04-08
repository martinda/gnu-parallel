#!/bin/bash

echo '### Test {#}'
seq 1 10 | parallel -k echo {#}

echo '### Test --seqreplace and line too long'
seq 1 100 | stdout parallel -k --seqreplace I echo $(perl -e 'print "I"x130000') \|wc
