#!/bin/bash

SERVER1=parallel-server3
SERVER2=parallel-server2

echo '### Test --trc with space added in filename'
echo original > '/tmp/parallel space file'
echo '/tmp/parallel space file' | stdout parallel --trc "{} more space" -S parallel@$SERVER1 cat {} ">{}\\ more\\ space"
cat '/tmp/parallel space file more space'
rm '/tmp/parallel space file more space'

echo '### Test --trc with >|< added in filename'
echo original > '/tmp/parallel space file'
echo '/tmp/parallel space file' | stdout parallel --trc "{} >|<" -S parallel@$SERVER1 cat {} ">{}\\ \\>\\|\\<"
cat '/tmp/parallel space file >|<'
rm '/tmp/parallel space file >|<'

echo '### Test --return with fixed string (Gave undef warnings)'
touch a
echo a | stdout parallel --return b -S .. echo ">b" && echo OK
rm a b

echo '### bug #35427: quoting of {2} broken for --onall'
echo foo: /bin/ls | parallel --colsep ' ' -S localhost --onall ls {2}
