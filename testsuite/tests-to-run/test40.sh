#!/bin/bash

echo "### Computing length of command line"
seq 1 2 | parallel -k -N2 echo {1} {2} 
parallel -k -a <(seq 11 12) -a <(seq 1 3) echo
parallel -k -C %+ echo '"{1}_{3}_{2}_{4}"' ::: 'a% c %%b' 'a%c% b %d'
parallel -k -C %+ echo {4} ::: 'a% c %%b'
