#!/bin/bash

echo '### Test of -j filename'
stdout parallel -j no_such_file echo ::: 1

echo '### Test of -j filename'
echo 3 >/tmp/jobs_to_run
parallel -j /tmp/jobs_to_run -v sleep 0.{} ::: 9 8 7 6 5
# Should give 7 8 9 5 6

echo '### Test of -j filename with file content changing'
(echo 1 >/tmp/jobs_to_run; sleep 3; echo 10 >/tmp/jobs_to_run) &
parallel  -j /tmp/jobs_to_run -v sleep {} ::: 3.3 1.1 1.3 1.4 1.2 1 1 1 1 1 1 1 1 1 1 1
