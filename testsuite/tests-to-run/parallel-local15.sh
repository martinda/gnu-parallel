#!/bin/bash

TMP=/run/shm/parallel_$$

rsync -Ha --delete input-files/testdir/ $TMP/
cd $TMP/

echo echo test of cat pipe sh | parallel -j 50 2>&1
find . -name '*.jpg' | parallel -j +0 convert -geometry 120 {} {//}/thumb_{/}

ls | parallel ls | sort
ls | parallel echo ls | sort
ls | parallel -j 1 echo ls | sort
find -type f | parallel diff {} a/foo ">"{}.diff | sort
ls | parallel -v --group "ls {}|wc;echo {}" | sort
echo '### Check that we can have more input than max procs (-j 0) - touch'
perl -e 'print map {"more_than_5000-$_\n" } (4000..9999)' | parallel -vj 0 touch | sort | tail
echo '### rm'
perl -e 'print map {"more_than_5000-$_\n" } (4000..9900)' | parallel -j 0 rm | sort
cat <<'EOF' | sed -e 's/;$/; /;s/$SERVER1/'$SERVER1'/;s/$SERVER2/'$SERVER2'/' | stdout nice parallel -k -L1
ls | parallel -j500 'sleep 1; find {} -type f | perl -ne "END{print $..\" {}\n\"}"' | sort
ls | parallel --group -j500 'sleep 1; find {} -type f | perl -ne "END{print $..\" {}\n\"}"' | sort
find . -type f | parallel --group  "perl -ne '/^\\S+\\s+\\S+$/ and print \$ARGV,\"\\n\"'" | sort
find . -type f | parallel -v --group "perl -ne '/^\\S+\\s+\\S+$/ and print \$ARGV,\"\\n\"'" | sort
find . -type f | parallel -q --group  perl -ne '/^\S+\s+\S+$/ and print $ARGV,"\n"' | sort
find . -type f | parallel -qv --group perl -ne '/^\S+\s+\S+$/ and print $ARGV,"\n"' | sort
EOF

cd -
rm -rf $TMP/
