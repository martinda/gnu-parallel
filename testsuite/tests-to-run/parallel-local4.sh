#!/bin/bash

cat <<'EOF' | parallel -j0 -vk
echo '### bug #36595: silent loss of input with --pipe and --sshlogin'
  seq 10000 | xargs | parallel --pipe -S 10/localhost cat | wc

echo 'bug #36707: --controlmaster eats jobs'
  seq 2 | parallel -k --controlmaster --sshlogin localhost echo OK{}
EOF
