#!/bin/bash

cat <<'EOF' | sed -e 's/$SERVER1/'$SERVER1'/;s/$SERVER2/'$SERVER2'/' | stdout parallel -j3 -k -L1
EOF
