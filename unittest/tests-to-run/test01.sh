#!/bin/bash

rm -rf tmp 2>/dev/null
cp -a input-files/testdir tmp
cd tmp

echo echo test of cat pipe sh | parallel -j 50 2>&1
find . -name '*.jpg' | parallel -j +0 convert -geometry 120 {} {}_thumb.jpg 
find . -name '*_thumb.jpg' | ren 's:/([^/]+)_thumb.jpg$:/thumb_$1:' 

ls | parallel ls | sort
ls | parallel echo ls | sort
ls | parallel -j 1 echo ls | sort
find -type f | parallel diff {} a/foo ">"{}.diff | sort
ls | parallel -vg "ls {}|wc;echo {}" | sort
# Check that we can have more input than max procs (-j 0)
perl -e 'print map {"more_than_5000-$_\n" } (4000..9999)' | parallel -vj 0 touch | sort | tail
perl -e 'print map {"more_than_5000-$_\n" } (4000..9900)' | parallel -j 0 rm | sort
ls | parallel -j500 'sleep 1; ls {} | perl -ne "END{print $..\" {}\n\"}"' | sort
ls | parallel -gj500 'sleep 1; ls {} | perl -ne "END{print $..\" {}\n\"}"' | sort
ls | parallel -g  "perl -ne '/^\\S+\\s+\\S+$/ and print \$ARGV,\"\\n\"'" | sort
ls | parallel -vg "perl -ne '/^\\S+\\s+\\S+$/ and print \$ARGV,\"\\n\"'" | sort
ls | parallel -qg  perl -ne '/^\S+\s+\S+$/ and print $ARGV,"\n"' | sort
ls | parallel -qvg perl -ne '/^\S+\s+\S+$/ and print $ARGV,"\n"' | sort

cd ..
rm -rf tmp
