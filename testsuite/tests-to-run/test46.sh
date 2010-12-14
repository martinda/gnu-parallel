#!/bin/bash

SERVER1=parallel-server3
SERVER2=parallel-server2

echo '### Test --trc with space added in filename'
echo original > '/tmp/parallel space file'
echo '/tmp/parallel space file' | parallel --trc "{} more space" -S $SERVER1 cat {} ">{}\\ more\\ space"
cat '/tmp/parallel space file more space'

echo '### Test --trc with >|< added in filename'
echo original > '/tmp/parallel space file'
echo '/tmp/parallel space file' | parallel --trc "{} >|<" -S $SERVER1 cat {} ">{}\\ \\>\\|\\<"
cat '/tmp/parallel space file >|<'
