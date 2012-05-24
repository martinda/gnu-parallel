#!/bin/bash

TMP=/tmp/parallel_local105
rm -rf $TMP 2>/dev/null
mkdir -p $TMP
tar -C $TMP -xf input-files/random_dirs_with_newline.tar.bz2

cd $TMP/random_dirs_with_newline

# tests if special dir names causes problems
find . -type d -print0 | perl -0 -pe 's:^./::' | parallel -0 -v touch -- {}/abc-{}-{} 2>&1 \
 | perl -e 'print sort (<>)' | md5sum
echo -n 'There are ' 
find . -type d -print0 | perl -0 -ne '$a++;END{print $a}'
echo -n ' dirs with '
find . -type f -print0 | perl -0 -ne '$a++;END{print $a}'
echo ' files'
echo 'Removing files'
find . -type d -print0 |  perl -0 -pe 's:^./::' | parallel -0 -v rm -- {}/abc-{}-{} 2>&1 \
 | perl -e 'print sort (<>)' | md5sum
echo -n 'There are ' 
find . -type d -print0 | perl -0 -ne '$a++;END{print $a}'
echo -n ' dirs with '
find . -type f -print0 | perl -0 -ne '$a++;END{print $a}'
echo ' files'
echo 'Removing dirs'
find . -type d -print0 |  perl -0 -pe 's:^./::' | parallel -0 -v rmdir -- {} 2>&1 \
 | perl -e 'print sort (<>)' | md5sum
echo -n 'There are ' 
find . -type d -print0 | perl -0 -ne '$a++;END{print $a}'
echo -n ' dirs with '
find . -type f -print0 | perl -0 -ne '$a++;END{print $a}'
echo ' files'

cd ..
rm -rf $TMP

