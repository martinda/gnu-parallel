#!/bin/bash

rm -rf tmp 2>/dev/null
cp -a input-files/testdir tmp
cd tmp

find . -name '*.jpg' | parallel -j +0 convert -geometry 120 {} {}_thumb.jpg 
find . -name '*_thumb.jpg' | ren 's:/([^/]+)_thumb.jpg$:/thumb_$1:' 

ls | grep -v CVS | parallel ls | grep -v CVS | sort
ls | grep -v CVS | parallel echo ls | grep -v CVS | sort
ls | grep -v CVS | parallel -j 1 echo ls | grep -v CVS | sort
find -type f | grep -v CVS | parallel diff {} a/foo ">"{}.diff | grep -v CVS | sort
ls | grep -v CVS | parallel -vg "ls {}|wc;echo {}" | grep -v CVS | sort
perl -e 'print map {"more_than_5000-$_\n" } (1..6000)' | parallel -j 100 touch | sort
perl -e 'print map {"more_than_5000-$_\n" } (1..5900)' | parallel -j 100 rm | sort
ls | grep -v CVS | parallel -j500 'sleep 1; ls {} | perl -ne "END{print $..\" {}\n\"}"' | grep -v CVS | sort
ls | grep -v CVS | parallel -gj500 'sleep 1; ls {} | perl -ne "END{print $..\" {}\n\"}"' | grep -v CVS | sort
ls | grep -v CVS | parallel -g  "perl -ne '/^\\S+\\s+\\S+$/ and print \$ARGV,\"\\n\"'" | grep -v CVS | sort
ls | grep -v CVS | parallel -vg "perl -ne '/^\\S+\\s+\\S+$/ and print \$ARGV,\"\\n\"'" | grep -v CVS | sort
ls | grep -v CVS | parallel -qg  perl -ne '/^\S+\s+\S+$/ and print $ARGV,"\n"' | grep -v CVS | sort
ls | grep -v CVS | parallel -qvg perl -ne '/^\S+\s+\S+$/ and print $ARGV,"\n"' | grep -v CVS | sort

cd ..
rm -rf tmp
