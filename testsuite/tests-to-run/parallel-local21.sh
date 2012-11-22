#!/bin/bash

seq 1 2 >/tmp/in12
seq 4 5 >/tmp/in45

echo "### Test basic --shebang-wrap"
cat <<EOF > /tmp/basic--shebang-wrap
#!/usr/local/bin/parallel --shebang-wrap /usr/bin/perl

print "Shebang from perl with args @ARGV\n";
EOF

chmod 755 /tmp/basic--shebang-wrap
/tmp/basic--shebang-wrap arg1 arg2
echo "### Same as"
parallel /usr/bin/perl /tmp/basic--shebang-wrap ::: arg1 arg2
echo "### stdin"
(echo arg1; echo arg2) | /tmp/basic--shebang-wrap
echo "### Same as"
(echo arg1; echo arg2) | parallel /usr/bin/perl /tmp/basic--shebang-wrap
rm /tmp/basic--shebang-wrap


echo "### Test --shebang-wrap with parser options"
cat <<EOF > /tmp/with-parser--shebang-wrap
#!/usr/local/bin/parallel --shebang-wrap /usr/bin/perl -p

print "Shebang from perl with args @ARGV\n";
EOF

chmod 755 /tmp/with-parser--shebang-wrap
/tmp/with-parser--shebang-wrap /tmp/in12 /tmp/in45
echo "### Same as"
parallel /usr/bin/perl -p /tmp/with-parser--shebang-wrap ::: /tmp/in12 /tmp/in45
echo "### stdin"
(echo /tmp/in12; echo /tmp/in45) | /tmp/with-parser--shebang-wrap
echo "### Same as"
(echo /tmp/in12; echo /tmp/in45) | parallel /usr/bin/perl /tmp/with-parser--shebang-wrap
rm /tmp/with-parser--shebang-wrap


echo "### Test --shebang-wrap --pipe with parser options"
cat <<EOF > /tmp/pipe--shebang-wrap
#!/usr/local/bin/parallel --shebang-wrap --pipe /usr/bin/perl -p

print "Shebang from perl with args @ARGV\n";
EOF

chmod 755 /tmp/pipe--shebang-wrap
# Suboptimal
/tmp/pipe--shebang-wrap :::: /tmp/in12 /tmp/in45
# Optimal
/tmp/pipe--shebang-wrap /tmp/in12 /tmp/in45
echo "### Same as"
parallel --pipe /usr/bin/perl\ -p /tmp/pipe--shebang-wrap :::: /tmp/in12 /tmp/in45
echo "### stdin"
cat /tmp/in12 /tmp/in45 | /tmp/pipe--shebang-wrap
echo "### Same as"
cat /tmp/in12 /tmp/in45 | parallel --pipe /usr/bin/perl\ -p /tmp/pipe--shebang-wrap
rm /tmp/pipe--shebang-wrap

rm /tmp/in12
rm /tmp/in45
