#!/bin/bash

PAR=parallel

echo Force outside the file handle limit
# 2009-02-17 Gave fork error 
(echo echo Start;
 seq 1 20000 | perl -pe 's/^/true /';
 echo echo end) | $PAR -uj 0 

