#!/bin/bash

cat <<'EOF' | sed -e 's/;$/; /;s/$SERVER1/'$SERVER1'/;s/$SERVER2/'$SERVER2'/' | stdout parallel -j0 -k -L1
echo "### Test -I"
seq 1 10 | parallel -k 'seq 1 {} | parallel -k -I :: echo {} ::'

echo "### Test -X -I"
seq 1 10 | parallel -k 'seq 1 {} | parallel -j1 -X -k -I :: echo a{} b::'

echo "### Test -m -I"
seq 1 10 | parallel -k 'seq 1 {} | parallel -j1 -m -k -I :: echo a{} b::'

echo "### Test max line length -m -I"
seq 1 60000 | parallel -I :: -m -j1 echo a::b::c | 
  mop -q "|sort |md5sum" :par1; 
  export CHAR=$(cat ~/.mop/:par1 | wc -c); 
  export LINES=$(cat ~/.mop/:par1 | wc -l); 
  echo -n "Chars per line ($CHAR/$LINES): "; 
  echo "$CHAR/$LINES" | bc

echo "### Test max line length -X -I"
seq 1 60000 | parallel -I :: -X -j1 echo a::b::c | 
  mop -q "|sort |md5sum" :par; 
  export CHAR=$(cat ~/.mop/:par | wc -c); 
  export LINES=$(cat ~/.mop/:par | wc -l); 
  echo -n "Chars per line ($CHAR/$LINES): "; 
  echo "$CHAR/$LINES" | bc

echo "### bug #36659: --sshlogin strips leading slash from ssh command"
parallel --sshlogin '/usr/bin/ssh localhost' echo ::: OK
EOF
