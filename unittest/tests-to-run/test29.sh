#!/bin/bash

echo '### Test of quoting of > bug'
echo '>/dev/null' | parallel echo

echo '### Test of quoting of > bug if line continuation'
(echo '> '; echo '> '; echo '>') | parallel --max-lines 3 echo

echo '### Test of --trim illegal'
stdout parallel --trim fj ::: echo

echo '### Test of --colsep'
echo 'a%c%b' | parallel --colsep % echo {1} {3} {2}
(echo 'a%c%b'; echo a%c%b%d) | parallel -k --colsep % echo {1} {3} {2} {4}
(echo a%c%b; echo d%f%e) | parallel -k --colsep % echo {1} {3} {2}
parallel -k --colsep % echo {1} {3} {2} ::: a%c%b d%f%e

parallel -k --colsep % echo {1} {3} {2} ::: a%c%b

parallel -k --colsep % echo {1} {3} {2} {4} ::: a%c%b a%c%b%d

echo '### Test of --colsep as regexp'
(echo 'a%c%%b'; echo a%c%b%d) | parallel -k --colsep %+ echo {1} {3} {2} {4}

parallel -k --colsep %+ echo {1} {3} {2} {4} ::: a%c%%b a%c%b%d


(echo 'a% c %%b'; echo a%c% b %d) | parallel -k --colsep %+ echo {1} {3} {2} {4}

(echo 'a% c %%b'; echo a%c% b %d) | parallel -k --colsep %+ echo '"{1}_{3}_{2}_{4}"'
echo '### Test of -C'
(echo 'a% c %%b'; echo a%c% b %d) | parallel -k -C %+ echo '"{1}_{3}_{2}_{4}"'
echo '### Test of --trim n'
(echo 'a% c %%b'; echo a%c% b %d) | parallel -k --trim n --colsep %+ echo '"{1}_{3}_{2}_{4}"'
parallel -k -C %+ echo '"{1}_{3}_{2}_{4}"' ::: 'a% c %%b' 'a%c% b %d'
