#!/bin/bash

SERVER1=parallel-server3
SERVER2=parallel-server2

cat <<'EOF' | sed -e s/\$SERVER1/$SERVER1/\;s/\$SERVER2/$SERVER2/ | parallel -k
echo '### Test --onall'
parallel --onall -S parallel@$SERVER2,$SERVER1 '(echo {3} {2}) | awk \{print\ \$2}' ::: a b c ::: 1 2 3
echo '### Test | --onall'
seq 3 | parallel --onall -S parallel@$SERVER2,$SERVER1 '(echo {3} {2}) | awk \{print\ \$2}' ::: a b c :::: -
echo '### Test --onall -u'
parallel --onall -S parallel@$SERVER2,$SERVER1 -u '(echo {3} {2}) | awk \{print\ \$2}' ::: a b c ::: 1 2 3 | sort
echo '### Test --nonall'
parallel --nonall -S parallel@$SERVER2,$SERVER1 'hostname'
parallel --nonall -S parallel@$SERVER2,$SERVER1 -u 'hostname;sleep 2;hostname'
echo '### Test read sshloginfile from STDIN'
echo nlv.pi.dk | parallel -S - --nonall hostname
echo nlv.pi.dk | parallel --sshloginfile - --nonall hostname
EOF
