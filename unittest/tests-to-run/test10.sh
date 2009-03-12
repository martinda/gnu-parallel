#!/bin/bash

# This causes problems if we kill child processes
seq 1 40 | parallel -j 0 seq 1 10  | sort |md5sum
seq 1 40 | parallel -j 0 seq 1 10 '| parallel -j 3 echo' | sort |md5sum

# Test of xargs
seq 1 80000 | parallel -x echo  | mop -d 4 "|sort |md5sum" "| wc" 
