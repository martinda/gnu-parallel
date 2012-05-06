#!/bin/bash

echo '### Test fix #32191'
seq 1 150 | parallel -j9 --retries 2 -S localhost,: "/bin/non-existant 2>/dev/null"

echo '### Test --tagstring'
parallel -j1 -X -v --tagstring a{}b echo  ::: 3 4
parallel -j1 -k -v --tagstring a{}b echo  ::: 3 4
parallel -j1 -k -v --tagstring a{}b echo job{#} ::: 3 4
parallel -j1 -k -v --tagstring ajob{#}b echo job{#} ::: 3 4

