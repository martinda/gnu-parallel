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

echo "### Test stdin as tty input for 'vi'"
echo 'NB: If this changes and the diff is printed to terminal, then'
echo "the terminal settings may be fucked up. Use 'reset' to get back."
cat >/tmp/parallel-script-for-script3 <<EOF
#!/bin/bash
seq 10 | parallel --tty -X vi file{}
EOF
chmod 755 /tmp/parallel-script-for-script3
echo ZZZZ | script -q -f -c /tmp/parallel-script-for-script3 /dev/null
sleep 2
rm /tmp/parallel-script-for-script3

touch ~/.parallel/will-cite
