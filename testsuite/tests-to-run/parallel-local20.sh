#!/bin/bash

echo '### Test of #! --shebang'
cat >/tmp/shebang <<EOF
#!/usr/local/bin/parallel --shebang -rk echo
A
B
C
EOF
chmod 755 /tmp/shebang
/tmp/shebang

echo '### Test of #! --hashbang'
cat >/tmp/shebang <<EOF
#!/usr/local/bin/parallel --hashbang -rk echo
A
B
C
EOF
chmod 755 /tmp/shebang
/tmp/shebang

echo '### Test of #! with 2 files as input (2 columns)'
cat >/tmp/shebang <<EOF
#!/usr/local/bin/parallel --shebang -rk --xapply -a /tmp/123 echo
A
B
C
EOF
chmod 755 /tmp/shebang
seq 1 3 >/tmp/123
/tmp/shebang
echo '### bug #36595: silent loss of input with --pipe and --sshlogin'
seq 10000 | xargs | parallel --pipe -S 10/localhost cat | wc
