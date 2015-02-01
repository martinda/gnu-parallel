#!/bin/bash

rm -f ~/.parallel/will-cite

echo '### Test stdin goes to first command only ("-" as argument)'
cat >/tmp/parallel-script-for-script <<EOF
#!/bin/bash
echo via first cat |parallel --tty -kv cat ::: - -
EOF
chmod 755 /tmp/parallel-script-for-script
echo via pseudotty | script -q -f -c /tmp/parallel-script-for-script /dev/null
sleep 2
rm /tmp/parallel-script-for-script

echo '### Test stdin goes to first command only ("cat" as argument)'
cat >/tmp/parallel-script-for-script2 <<EOF
#!/bin/bash
echo no output |parallel --tty -kv ::: 'echo a' 'cat'
EOF
chmod 755 /tmp/parallel-script-for-script2
echo via pseudotty | script -q -f -c /tmp/parallel-script-for-script2 /dev/null
sleep 2
rm /tmp/parallel-script-for-script2

touch ~/.parallel/will-cite
