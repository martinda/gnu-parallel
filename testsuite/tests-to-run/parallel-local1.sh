#!/bin/bash

cat <<'EOF' | parallel -j0 -k
echo "### Test --basenamereplace"
parallel -j1 -k -X --basenamereplace FOO echo FOO ::: /a/b.c a/b.c b.c /a/b a/b b
parallel -k --basenamereplace FOO echo FOO ::: /a/b.c a/b.c b.c /a/b a/b b

echo "### Test --bnr"
parallel -j1 -k -X --bnr FOO echo FOO ::: /a/b.c a/b.c b.c /a/b a/b b
parallel -k --bnr FOO echo FOO ::: /a/b.c a/b.c b.c /a/b a/b b

echo "### Test --extensionreplace"
parallel -j1 -k -X --extensionreplace FOO echo FOO ::: /a/b.c a/b.c b.c /a/b a/b b
parallel -k --extensionreplace FOO echo FOO ::: /a/b.c a/b.c b.c /a/b a/b b

echo "### Test --er"
parallel -j1 -k -X --er FOO echo FOO ::: /a/b.c a/b.c b.c /a/b a/b b
parallel -k --er FOO echo FOO ::: /a/b.c a/b.c b.c /a/b a/b b

echo "### Test --basenameextensionreplace"
parallel -j1 -k -X --basenameextensionreplace FOO echo FOO ::: /a/b.c a/b.c b.c /a/b a/b b
parallel -k --basenameextensionreplace FOO echo FOO ::: /a/b.c a/b.c b.c /a/b a/b b

echo "### Test --bner"
parallel -j1 -k -X --bner FOO echo FOO ::: /a/b.c a/b.c b.c /a/b a/b b
parallel -k --bner FOO echo FOO ::: /a/b.c a/b.c b.c /a/b a/b b

echo "### Test {/}"
parallel -j1 -k -X echo {/} ::: /a/b.c a/b.c b.c /a/b a/b b

echo "### Test {/.}"
parallel -j1 -k -X echo {/.} ::: /a/b.c a/b.c b.c /a/b a/b b

echo "### Test {#/.}"
parallel -j1 -k -X echo {2/.} ::: /a/number1.c a/number2.c number3.c /a/number4 a/number5 number6

echo "### Test {#/}"
parallel -j1 -k -X echo {2/} ::: /a/number1.c a/number2.c number3.c /a/number4 a/number5 number6

echo "### Test {#.}"
parallel -j1 -k -X echo {2.} ::: /a/number1.c a/number2.c number3.c /a/number4 a/number5 number6

echo "### bug #34241: --pipe should not spawn unneeded processes"
echo | parallel -r -j2 -N1 --pipe md5sum -c && echo OK
EOF
