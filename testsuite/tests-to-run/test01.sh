#!/bin/bash

PAR=parallel

rsync -Ha --delete input-files/testdir/ tmp/
cd tmp

echo echo test of cat pipe sh | $PAR -j 50 2>&1
find . -name '*.jpg' | $PAR -j +0 convert -geometry 120 {} {}_thumb.jpg 
find . -name '*_thumb.jpg' | ren 's:/([^/]+)_thumb.jpg$:/thumb_$1:' 

ls | $PAR ls | sort
ls | $PAR echo ls | sort
ls | $PAR -j 1 echo ls | sort
find -type f | $PAR diff {} a/foo ">"{}.diff | sort
ls | $PAR -vg "ls {}|wc;echo {}" | sort
echo '### Check that we can have more input than max procs (-j 0)'
perl -e 'print map {"more_than_5000-$_\n" } (4000..9999)' | $PAR -vj 0 touch | sort | tail
perl -e 'print map {"more_than_5000-$_\n" } (4000..9900)' | $PAR -j 0 rm | sort
ls | $PAR -j500 'sleep 1; ls {} | perl -ne "END{print $..\" {}\n\"}"' | sort
ls | $PAR -gj500 'sleep 1; ls {} | perl -ne "END{print $..\" {}\n\"}"' | sort
ls | $PAR -g  "perl -ne '/^\\S+\\s+\\S+$/ and print \$ARGV,\"\\n\"'" | sort
ls | $PAR -vg "perl -ne '/^\\S+\\s+\\S+$/ and print \$ARGV,\"\\n\"'" | sort
ls | $PAR -qg  perl -ne '/^\S+\s+\S+$/ and print $ARGV,"\n"' | sort
ls | $PAR -qvg perl -ne '/^\S+\s+\S+$/ and print $ARGV,"\n"' | sort

cd ..
rm -rf tmp
