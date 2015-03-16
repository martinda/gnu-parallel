#!/bin/bash

make stopvm

# Jobs that eat more than 2 GB RAM
cat <<'EOF' | sed -e 's/;$/; /;s/$SERVER1/'$SERVER1'/;s/$SERVER2/'$SERVER2'/' | stdout parallel -vj1 -k --joblog /tmp/jl-`basename $0` -L1
echo '### Trouble reading a record > 2 GB for certain versions of Perl (substr($a,0,2G+1)="fails")'
echo '### perl -e $buf=("x"x(2**31))."x"; substr($buf,0,2**31+1)=""; print length $buf'
echo 'Eats 4 GB'
perl -e '$buf=("x"x(2**31))."x"; substr($buf,0,2**31+1)=""; print length $buf."\n"'

echo 'Eats 2.5 GB'
  (yes "`seq 3000`" | head -c 2300M; echo ged) | 
  PERL5LIB=input-files/perl-v5.14.2/lib input-files/perl-v5.14.2/perl `which parallel` -k --block 2G --pipe --recend ged md5sum
echo 'Eats 2.5 GB'
  (yes "`seq 3000`" | head -c 2300M; echo ged) | 
  PERL5LIB=input-files/perl-v5.14.2/lib input-files/perl-v5.14.2/perl `which parallel` -k --block 2G --pipe --recend ged cat | wc -c

echo '**'

echo '### bug #44358: 2 GB records cause problems for -N'
echo '5 GB version: Eats 12.5 GB'
  (yes "`seq 3000`" | head -c 5000000000; echo FOO; 
   yes "`seq 3000`" | head -c 3000000000; echo FOO; 
   yes "`seq 3000`" | head -c 1000000000;) | 
   PERL5LIB=input-files/perl-v5.14.2/lib input-files/perl-v5.14.2/perl 
   `which parallel` --pipe --recend FOO -N2 --block 1g -k LANG=c wc -c

echo '2 GB version: eats 10 GB'
  (yes "`seq 3000`" | head -c 2300M; echo FOO; 
   yes "`seq 3000`" | head -c 2300M; echo FOO; 
   yes "`seq 3000`" | head -c 1000M;) | 
   PERL5LIB=input-files/perl-v5.14.2/lib input-files/perl-v5.14.2/perl 
   `which parallel` --pipe --recend FOO -N2 --block 1g -k LANG=c wc -c

echo '### -L >4GB'
  (head -c 5000000000 /dev/zero; echo FOO; 
   head -c 3000000000 /dev/zero; echo FOO; 
   head -c 1000000000 /dev/zero;) | 
   parallel --pipe  -L2 --block 1g -k LANG=c wc -c

EOF

make startvm