#!/bin/bash -x

rsync -Ha --delete input-files/segfault/ tmp/
cd tmp

echo '### Test of segfaulting issue'
echo 'This gave /home/tange/bin/stdout: line 3: 20374 Segmentation fault      "$@" 2>&1'
echo 'before adding wait() before exit'
seq 1 300 | stdout parallel ./trysegfault