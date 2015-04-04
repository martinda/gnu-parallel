#!/bin/bash

cd testsuite 2>/dev/null
mkdir -p tmp
cd tmp
echo '### test parallel_tutorial'
rm -f /tmp/runs
export SERVER1=parallel@lo
export SERVER2=csh@lo
export PARALLEL=-k
perl -ne '$/="\n\n"; /^Output/../^[^O]\S/ and next; /^  / and print;' ../../src/parallel_tutorial.pod |
  egrep -v 'curl|tty|parallel_tutorial|interactive|example.(com|net)|shellquote|works' |
  perl -pe 's/username@//;s/user@//;
            s/zenity/zenity --timeout=12/;
            s:/usr/bin/time:/usr/bin/time -f %e:;
            s:ignored_vars:ignored_vars|sort:;
' |
  stdout bash -x |
  perl -pe '$|=1;
            # --files and --tmux
            s:/tmp/par......(...):/tmp/parXXXXX.$1:;
            # --eta --progress
            s/ETA.*//g; s/local:.*//g;
            # Sat Apr  4 11:55:40 CEST 2015
            s/... ... .. ..:..:.. \D+ ..../DATE OUTPUT/;
            # Timestamp from --joblog
            s/\d{10}.\d{3}\s+..\d+/TIMESTAMP\t9.999/g;
            # Remote script
            s/(PARALLEL_PID\D+)\d+/${1}000000/g;
            # /usr/bin/time -f %e
            s/^(\d+)\.\d+$/$1/;
            # Base 64 string
            s:[+/a-z0-9=]{50,}:BASE64:ig;
            # --workdir ...
            s:parallel/tmp/aspire-\d+-1:TMPWORKDIR:g;
            # + cat ... | (Bash outputs these in random order)
            s/\+ cat.*\n//;
            # + echo ... | (Bash outputs these in random order)
            s/\+ echo.*\n//;
            # + wc ... (Bash outputs these in random order)
            s/\+ wc.*\n//;
            # + command_X | (Bash outputs these in random order)
            s/.*command_[ABC].*\n//;
'
# parallel -d'\n\n' 
