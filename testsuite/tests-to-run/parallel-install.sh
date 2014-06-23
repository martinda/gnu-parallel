#!/bin/bash

echo '### Test installation missing pod2*'

parallel which ::: pod2html pod2man pod2texi pod2pdf | sudo parallel mv {} {}.hidden

cd ~/privat/parallel
stdout make dist | perl -pe 's/\d{8}/00000000/g'
LAST=$(ls *tar.gz | tail -n1)
cd /tmp
rm -rf parallel-20??????/
tar xf ~/privat/parallel/$LAST
cd parallel-20??????/
touch src/*pod src/sql
./configure && sudo stdout make install | perl -pe 's/\d{8}/00000000/g'

parallel which {}.hidden ::: pod2html pod2man pod2texi pod2pdf | sudo parallel mv {} {.}
