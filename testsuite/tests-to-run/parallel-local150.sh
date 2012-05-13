#!/bin/bash

echo '### Test fix #32191'
seq 1 150 | nice nice parallel -j9 --retries 2 -S localhost,: "/bin/non-existant 2>/dev/null"

echo '### Test --tagstring'
parallel -j1 -X -v --tagstring a{}b echo  ::: 3 4
parallel -j1 -k -v --tagstring a{}b echo  ::: 3 4
parallel -j1 -k -v --tagstring a{}b echo job{#} ::: 3 4
parallel -j1 -k -v --tagstring ajob{#}b echo job{#} ::: 3 4

echo '### Test bug #35820: sem breaks if $HOME is not writable'
echo 'Workaround: use another writable dir'
rm -rf /tmp/.parallel
HOME=/tmp sem echo OK
HOME=/tmp sem --wait
HOME=/usr/this/should/fail stdout sem echo should fail
