#!/bin/bash

rm -rf tmp 2>/dev/null
cd input-files
tar xjf random_dirs_no_newline.tar.bz2 
cd ..
cp -a input-files/random_dirs_no_newline tmp
cd tmp

# tests if special dir names causes problems
ls | parallel -v touch -- {}/abc-{}-{} 2>&1 | perl -e 'print sort (<>)' | md5sum
echo -n 'There are ' 
find . -type d -print0 | perl -0 -ne '$a++;END{print $a}'
echo -n ' dirs with '
find . -type f -print0 | perl -0 -ne '$a++;END{print $a}'
echo ' files'
echo 'Removing files'
ls | parallel -v rm -- {}/abc-{}-{} 2>&1 | perl -e 'print sort (<>)' | md5sum
echo -n 'There are ' 
find . -type d -print0 | perl -0 -ne '$a++;END{print $a}'
echo -n ' dirs with '
find . -type f -print0 | perl -0 -ne '$a++;END{print $a}'
echo ' files'
echo 'Removing dirs'
ls | parallel -v rmdir -- {} 2>&1 | perl -e 'print sort (<>)' | md5sum
echo -n 'There are ' 
find . -type d -print0 | perl -0 -ne '$a++;END{print $a}'
echo -n ' dirs with '
find . -type f -print0 | perl -0 -ne '$a++;END{print $a}'
echo ' files'

cd ..
rm -rf tmp
