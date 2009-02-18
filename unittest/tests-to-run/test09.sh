#!/bin/bash

echo Force outside the file handle limit
# 2009-02-17 Gave fork error 
(echo echo Start;
 seq 1 100000 | perl -pe 's/^/true /';
 echo echo end) | parallel -uj 0 

