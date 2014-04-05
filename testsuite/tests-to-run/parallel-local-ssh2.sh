#!/bin/bash

cat <<'EOF' | sed -e s/\$SERVER1/$SERVER1/\;s/\$SERVER2/$SERVER2/ | stdout parallel -j8 -k -L1
echo '### --filter-hosts --slf <()'
  parallel --nonall --filter-hosts --slf <(echo localhost) echo OK

echo '### --wd no-such-dir'
  stdout parallel --wd /no-such-dir -S csh@localhost echo ::: 1; echo Exit code $?
  stdout parallel --wd /no-such-dir -S tcsh@localhost echo ::: 1; echo Exit code $?
  stdout parallel --wd /no-such-dir -S parallel@localhost echo ::: 1; echo Exit code $?
EOF
