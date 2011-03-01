#!/bin/bash

echo '### Test https://savannah.gnu.org/bugs/index.php?31716'
seq 1 5 | stdout parallel -k -l echo {} OK
seq 1 5 | stdout parallel -k -l 1 echo {} OK
echo '### -k -l -0'
printf '1\0002\0003\0004\0005\000' | stdout parallel -k -l -0 echo {} OK
echo '### -k -0 -l'
printf '1\0002\0003\0004\0005\000' | stdout parallel -k -0 -l echo {} OK
echo '### -k -0 -l 1'
printf '1\0002\0003\0004\0005\000' | stdout parallel -k -0 -l 1 echo {} OK
echo '### -k -0 -l 0'
printf '1\0002\0003\0004\0005\000' | stdout parallel -k -0 -l 0 echo {} OK
echo '### -k -0 -L -0 - -0 is argument for -L'
printf '1\0002\0003\0004\0005\000' | stdout parallel -k -0 -L -0 echo {} OK
echo '### -k -0 -L 0 - -L always takes arg'
printf '1\0002\0003\0004\0005\000' | stdout parallel -k -0 -L 0 echo {} OK
echo '### -k -0 -L 0 - -L always takes arg'
printf '1\0002\0003\0004\0005\000' | stdout parallel -k -L 0 -0 echo {} OK
echo '### -k -e -0'
printf '1\0002\0003\0004\0005\000' | stdout parallel -k -e -0 echo {} OK
echo '### -k -0 -e eof'
printf '1\0002\0003\0004\0005\000' | stdout parallel -k -0 -e eof echo {} OK
echo '### -k -i -0'
printf '1\0002\0003\0004\0005\000' | stdout parallel -k -i -0 echo {} OK
echo '### -k -0 -i repl'
printf '1\0002\0003\0004\0005\000' | stdout parallel -k -0 -i repl echo repl OK

