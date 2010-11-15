#!/bin/bash

echo '### Test with old perl libs'
# Old libraries are put into input-files/perllib
PERL5LIB=input-files/perllib:../input-files/perllib; export PERL5LIB

echo '### See if we get compile error'
echo perl | stdout parallel echo
echo '### See if we read modules outside perllib'
echo perl | stdout strace -ff parallel echo | grep open | grep perl | grep -v input-files/perllib

