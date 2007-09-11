#!/bin/bash

rm -rf tmp 2>/dev/null
cp -a input-files/testdir tmp
cd tmp

find . -name '*.jpg' | parallel -j +0 convert -geometry 120 {} {}_thumb.jpg 
find . -name '*_thumb.jpg' | ren 's:/([^/]+)_thumb.jpg$:/thumb_$1:' 

ls | parallel ls | sort
ls | parallel echo ls | sort
ls | parallel -j 1 echo ls | sort
find -type f | parallel diff {} a/foo ">"{}.diff | sort
ls | parallel -vg "ls {}|wc;echo {}" | sort
perl -e 'print map {"more_than_5000-$_\n" } (1..6000)' | parallel -j 100 touch | sort
perl -e 'print map {"more_than_5000-$_\n" } (1..5900)' | parallel -j 100 rm | sort
ls | parallel -j500 'sleep 1; ls {} | perl -ne "END{print $..\" {}\n\"}"' | sort
ls | parallel -gj500 'sleep 1; ls {} | perl -ne "END{print $..\" {}\n\"}"' | sort
ls | parallel -g  "perl -ne '/^\\S+\\s+\\S+$/ and print \$ARGV,\"\\n\"'" | sort
ls | parallel -vg "perl -ne '/^\\S+\\s+\\S+$/ and print \$ARGV,\"\\n\"'" | sort
ls | parallel -qg  perl -ne '/^\S+\s+\S+$/ and print $ARGV,"\n"' | sort
ls | parallel -qvg perl -ne '/^\S+\s+\S+$/ and print $ARGV,"\n"' | sort

cd ..
rm -rf tmp
