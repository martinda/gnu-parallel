#!/bin/bash

cat <<'EOF' | parallel -j0 -vk
echo '### Test if we can deal with output > 4 GB'
echo | niceload --io 9 -H parallel -q perl -e '"\$a=\"x\"x1000000;for(0..4300){print \$a}"' | md5sum

echo '### Test {#}'
seq 1 10 | parallel -k echo {#}

echo '### Test --seqreplace and line too long'
seq 1 100 | stdout parallel -k --seqreplace I echo $(perl -e 'print "I"x130000') \|wc

echo '### Test of --retries on unreachable host'
seq 2 | stdout parallel -k --retries 2 -v -S 4.3.2.1,: echo
EOF
