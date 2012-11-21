#!/bin/bash

echo '### Test niceload -q'
niceload -q perl -e '$a = "works";$b="This $a\n"; print($b);'
echo 

# Force swapping
MEMAVAIL=$(free | perl -ane '/buffers.cache:/ and print $F[3]')
while [ $MEMAVAIL -gt 1000000 ] ; do
  BS=$(echo $MEMAVAIL/10 | bc)
  (seq 1 10 | parallel -j0 -N0 timeout 15 nice dd if=/dev/zero bs=${BS}k '|' wc -c >/dev/null &)
  sleep 2
  MEMAVAIL=$(free | perl -ane '/buffers.cache:/ and print $F[3]')
done

#echo 1 | parallel --timeout 20 'seq 10000{} | gzip -1 | perl -e '\'\$a=join\"\",\<\>\;\ while\(1\)\{push\ @a,\$a\}\'


# niceload -q -l 5 perl -e '$a=join"",<>; while(1){push @a,$a}' &

cat <<'EOF' | stdout parallel -j0 -k -L1
echo '### --rm and --runmem'
  niceload  -H --rm 1g free -g | perl -ane '/buffers.cache:/ and print $F[3],"\n"' | grep '[1-9]' >/dev/null && echo OK--rm
  niceload  -H --runmem 1g free -g | perl -ane '/buffers.cache:/ and print $F[3],"\n"' | grep '[1-9]' >/dev/null && echo OK--runmem

echo '### -N and --noswap. Must give 0'
  niceload -H -N vmstat 1 2 | tail -n1 | awk '{print "-N " $7*$8}'
  niceload -H --noswap vmstat 1 2 | tail -n1 | awk '{print "--noswap " $7*$8}'
EOF

# force load > 10
while uptime | grep -v age:.[1-9][0-9].[0-9][0-9] >/dev/null ; do (timeout 5 nice burnP6 2>/dev/null &) done

cat <<'EOF' | stdout parallel -j0 -k -L1
echo '### -H and --hard'
  niceload  -H -l 9.9 uptime | grep ':.[1-9][0-9].[0-9][0-9],' || echo OK-l9.9
  niceload  --hard -l 9 uptime | grep ':.[1-9][0-9].[0-9][0-9],' || echo OK-l9
EOF

cat <<'EOF' | stdout parallel -j0 -L1
echo '### -f and --factor'
  niceload -H --factor 10 -l6 echo factor 10 finish last
  niceload -H -f 0.01 -l6 echo f 0.1 finish first
EOF

#echo '### Test niceload -p'
#sleep 3 &
#nice-load -v -p $!


