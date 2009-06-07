#!/bin/bash

# Test if we can deal with output > 4 GB
echo | parallel 'dd if=/dev/zero count=43 bs=100000k; echo 1; echo 2' | md5sum
