#!/bin/bash

echo "### Test basic --shebang-wrap"
cat <<EOF > /tmp/test--shebang-wrap
#!/usr/local/bin/parallel --shebang-wrap /usr/bin/perl

print "Shebang from perl with args @ARGV\n";
EOF

chmod 755 /tmp/test--shebang-wrap
/tmp/test--shebang-wrap arg1 arg2
echo "### Same as"
parallel /usr/bin/perl /tmp/test--shebang-wrap ::: arg1 arg2

echo "### Test --shebang-wrap with parser options"
cat <<EOF > /tmp/test--shebang-wrap
#!/usr/local/bin/parallel --shebang-wrap /usr/bin/perl -p

print "Shebang from perl with args @ARGV\n";
EOF

chmod 755 /tmp/test--shebang-wrap
/tmp/test--shebang-wrap <(seq 2) <(seq 11 12)
echo "### Same as"
parallel /usr/bin/perl\ -p /tmp/test--shebang-wrap ::: <(seq 2) <(seq 11 12)


