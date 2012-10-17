#!/bin/bash

echo '### Test with old perl libs'
# Old libraries are put into input-files/perllib
PERL5LIB=input-files/perllib:../input-files/perllib; export PERL5LIB

echo '### See if we get compile error'
PATH=input-files/perllib:../input-files/perllib:$PATH
perl32 `which parallel` ::: 'echo perl'
echo '### See if we read modules outside perllib'
echo perl | stdout strace -ff perl32 `which parallel` echo | grep open | grep perl | grep -v input-files/perllib
