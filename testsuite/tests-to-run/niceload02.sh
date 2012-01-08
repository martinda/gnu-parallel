#!/bin/bash

echo '### Test niceload exit code'
niceload "perl -e 'exit(3)'" ; echo $? eq 3
niceload "perl -e 'exit(0)'" ; echo $? eq 0
