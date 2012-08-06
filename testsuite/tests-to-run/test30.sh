#!/bin/bash


cat <<'EOF' | parallel -j0 -k
echo '### Test of --eta'
seq 1 10 | stdout parallel --eta "sleep 1; echo {}" | wc -l

echo '### Test of --eta with no jobs'
stdout parallel --eta "sleep 1; echo {}" < /dev/null

echo '### Test of --progress'
seq 1 10 | stdout parallel --progress "sleep 1; echo {}" | wc -l

echo '### Test of --progress with no jobs'
stdout parallel --progress "sleep 1; echo {}" < /dev/null

echo '### bug #34422: parallel -X --eta crashes with div by zero'
seq 2 | stdout parallel -X --eta echo

echo '### --timeout --onall on remote machines: 2*slept 1, 2 jobs failed'
parallel -j0 --timeout 6 --onall -S localhost,parallel@parallel-server1 'sleep {}; echo slept {}' ::: 1 8 9 ; echo jobs failed: $?

echo '### --pipe without command'
seq -w 10 | stdout parallel --pipe

echo '### bug #36260: {n} expansion in --colsep files fails for empty fields if all following fields are also empty'
echo A,B,, | parallel --colsep , echo {1}{3}{2}
EOF
