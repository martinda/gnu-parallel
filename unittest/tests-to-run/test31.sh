#!/bin/bash

echo '### Test of #! with file as input'
cat >/tmp/shebang <<EOF
#!/usr/local/bin/parallel -Yr echo
A
B
C
EOF
chmod 755 /tmp/shebang
/tmp/shebang

echo '### Test of #! with 2 files as input'
cat >/tmp/shebang <<EOF
#!/usr/local/bin/parallel -Yr -a /tmp/123 echo
A
B
C
EOF
chmod 755 /tmp/shebang
seq 1 3 >/tmp/123
/tmp/shebang

