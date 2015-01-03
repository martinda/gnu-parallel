#!/bin/bash

cat <<'EOF' | sed -e 's/;$/; /;s/$SERVER1/'$SERVER1'/;s/$SERVER2/'$SERVER2'/' | stdout parallel -vj0 -k --joblog /tmp/jl-`basename $0` -L1
echo "### --line-buffer"
  seq 10 | parallel -j20 --line-buffer  'seq {} 10 | pv -qL 10' > /tmp/parallel_l$$; 
  seq 10 | parallel -j20                'seq {} 10 | pv -qL 10' > /tmp/parallel_$$; 
  cat /tmp/parallel_l$$ | wc; 
  diff /tmp/parallel_$$ /tmp/parallel_l$$ >/dev/null ; echo These must diff: $?

echo "### --pipe --line-buffer"
  seq 200| parallel -N10 -L1 --pipe  -j20 --line-buffer --tagstring {#} pv -qL 10 > /tmp/parallel_pl$$; 
  seq 200| parallel -N10 -L1 --pipe  -j20               --tagstring {#} pv -qL 10 > /tmp/parallel_p$$; 
  cat /tmp/parallel_pl$$ | wc; 
  diff /tmp/parallel_p$$ /tmp/parallel_pl$$ >/dev/null ; echo These must diff: $?

echo "### --pipe --line-buffer --compress"
  seq 200| parallel -N10 -L1 --pipe  -j20 --line-buffer --compress --tagstring {#} pv -qL 10 | wc

echo "### bug #41482: --pipe --compress blocks at different -j/seq combinations"
  seq 1 | parallel -k -j2 --compress -N1 -L1 --pipe cat;
  echo echo 1-4 + 1-4
    seq 4 | parallel -k -j3 --compress -N1 -L1 -vv echo;
  echo 4 times wc to stderr to stdout
    (seq 4 | parallel -k -j3 --compress -N1 -L1 --pipe wc '>&2') 2>&1 >/dev/null
  echo 1 2 3 4
    seq 4 | parallel -k -j3 --compress echo;
  echo 1 2 3 4
    seq 4 | parallel -k -j1 --compress echo;
  echo 1 2
    seq 2 | parallel -k -j1 --compress echo;
  echo 1 2 3
    seq 3 | parallel -k -j2 --compress -N1 -L1 --pipe cat;

echo "### bug #41609: --compress fails"
  seq 12 | parallel --compress --compress-program bzip2 -k seq {} 1000000 | md5sum
  seq 12 | parallel --compress -k seq {} 1000000 | md5sum

echo "### --compress race condition (use nice): Fewer than 400 would run"
  seq 400| nice parallel -j200 --compress echo | wc

echo "### -v --pipe: Dont spawn too many - 1 is enough"
  seq 1 | parallel -j10 -v --pipe cat

echo "### Test -N0 and --tagstring (fails)"
  echo tagstring arg | parallel --tag -N0 echo foo

echo "### Test -I"; 
  seq 1 10 | parallel -k 'seq 1 {} | parallel -k -I :: echo {} ::'

echo "### Test -X -I"; 
  seq 1 10 | parallel -k 'seq 1 {} | parallel -j1 -X -k -I :: echo a{} b::'

echo "### Test -m -I"; 
  seq 1 10 | parallel -k 'seq 1 {} | parallel -j1 -m -k -I :: echo a{} b::'

echo "### Test max line length -m -I";
  seq 1 60000 | parallel -I :: -m -j1 echo a::b::c | 
  tee >(sort |md5sum) >/tmp/114-a$$;
  export CHAR=$(cat /tmp/114-a$$ | wc -c); 
  export LINES=$(cat /tmp/114-a$$ | wc -l); 
  echo "Chars per line ($CHAR/$LINES): "$(echo "$CHAR/$LINES" | bc); 
  rm /tmp/114-a$$

echo "### Test max line length -X -I"; 
  seq 1 60000 | parallel -I :: -X -j1 echo a::b::c | 
  tee >(sort |md5sum) >/tmp/114-b$$;
  export CHAR=$(cat /tmp/114-b$$ | wc -c); 
  export LINES=$(cat /tmp/114-b$$ | wc -l); 
  echo "Chars per line ($CHAR/$LINES): "$(echo "$CHAR/$LINES" | bc); 
  rm /tmp/114-b$$

echo "### bug #36659: --sshlogin strips leading slash from ssh command"; 
  parallel --sshlogin '/usr/bin/ssh localhost' echo ::: OK

echo "### bug #36660: --workdir mkdir does not use --sshlogin custom ssh"; 
  rm -rf /tmp/foo36660; 
  cd /tmp; echo OK > parallel_test.txt; 
  ssh () { echo Failed; }; 
  export -f ssh; 
  parallel --workdir /tmp/foo36660/bar --transfer --sshlogin '/usr/bin/ssh localhost' cat ::: parallel_test.txt; 

echo "bug #36657: --load does not work with custom ssh"; 
  cd /tmp; echo OK > parallel_test.txt; 
  ssh () { echo Failed; }; 
  export -f ssh; 
  parallel --load=1000% -S "/usr/bin/ssh localhost" echo ::: OK

echo "bug #34958: --pipe with record size measured in lines"; 
  seq 10 | parallel -k --pipe -L 4 cat\;echo bug 34958-1

echo "bug #37325: Inefficiency of --pipe -L"; 
  seq 2000 | parallel -k --pipe --block 1k -L 4 wc\;echo FOO | uniq

echo "bug #34958: --pipe with record size measured in lines"; 
  seq 10 | parallel -k --pipe -l 4 cat\;echo bug 34958-2

echo "### Test --results"; 
  mkdir -p /tmp/parallel_results_test; 
  parallel -k --results /tmp/parallel_results_test/testA echo {1} {2} ::: I II ::: III IIII; 
  ls /tmp/parallel_results_test/testA/*/*/*/*/*; rm -rf /tmp/parallel_results_test/testA*

echo "### Test --res"; 
  mkdir -p /tmp/parallel_results_test; 
  parallel -k --res /tmp/parallel_results_test/testD echo {1} {2} ::: I II ::: III IIII; 
  ls /tmp/parallel_results_test/testD/*/*/*/*/*; rm -rf /tmp/parallel_results_test/testD*

echo "### Test --result"; 
  mkdir -p /tmp/parallel_results_test; 
  parallel -k --result /tmp/parallel_results_test/testE echo {1} {2} ::: I II ::: III IIII; 
  ls /tmp/parallel_results_test/testE/*/*/*/*/*; rm -rf /tmp/parallel_results_test/testE*

echo "### Test --results --header :"; 
  mkdir -p /tmp/parallel_results_test; 
  parallel -k --header : --results /tmp/parallel_results_test/testB echo {1} {2} ::: a I II ::: b III IIII; 
  ls /tmp/parallel_results_test/testB/*/*/*/*/*; rm -rf /tmp/parallel_results_test/testB*

echo "### Test --results --header : named - a/b swapped"; 
  mkdir -p /tmp/parallel_results_test; 
  parallel -k --header : --results /tmp/parallel_results_test/testC echo {a} {b} ::: b III IIII ::: a I II;
  ls /tmp/parallel_results_test/testC/*/*/*/*/*; rm -rf /tmp/parallel_results_test/testC*

echo "### Test --results --header : piped"; 
  mkdir -p /tmp/parallel_results_test; 
  (echo Col; perl -e 'print "backslash\\tab\tslash/null\0eof\n"') | parallel  --header : --result /tmp/parallel_results_test/testF true; 
  find /tmp/parallel_results_test/testF/*/*/* | sort; rm -rf /tmp/parallel_results_test/testF*

echo "### Test --results --header : piped - non-existing column header"; 
  mkdir -p /tmp/parallel_results_test; 
  (printf "Col1\t\n"; printf "v1\tv2\tv3\n"; perl -e 'print "backslash\\tab\tslash/null\0eof\n"') | parallel --header : --result /tmp/parallel_results_test/testG true; find /tmp/parallel_results_test/testG/ | sort; rm -rf /tmp/parallel_results_test/testG*

EOF
