#!/bin/bash

cat <<'EOF' | parallel -j0 -k
echo '### Test -q'
parallel -kq perl -e '$ARGV[0]=~/^\S+\s+\S+$/ and print $ARGV[0],"\n"' ::: "a b" c "d e f" g "h i"

echo '### Test -q {#}'
parallel -kq echo {#} ::: a b
parallel -kq echo {\#} ::: a b
parallel -kq echo {\\#} ::: a b
EOF
