#!/bin/bash

echo '### Test niceload -q'
niceload -q perl -e '$a = "works";$b="This $a\n"; print($b);'
echo 

# Force less than 1 GB buffer+cache
MEMAVAIL=$(free | perl -ane '/buffers.cache:/ and print $F[3]')
while [ $MEMAVAIL -gt 1000000 ] ; do
  BS=$(echo $MEMAVAIL/10 | bc)
  (seq 1 5 | parallel -j0 -N0 timeout 10 nice dd if=/dev/zero of=/dev/null bs=${BS}k &)
  sleep 2;
  MEMAVAIL=$(free | perl -ane '/buffers.cache:/ and print $F[3]')
done

echo '### --rm and --runmem'
niceload  -H --rm 1g free -g | perl -ane '/buffers.cache:/ and print $F[3],"\n"' | grep '[1-9]' >/dev/null && echo OK &
niceload  -H --runmem 1.2g free -g | perl -ane '/buffers.cache:/ and print $F[3],"\n"' | grep '[1-9]' >/dev/null && echo OK &
wait


# Force swapping
MEMAVAIL=$(free | perl -ane '/buffers.cache:/ and print $F[3]')
while [ $MEMAVAIL -gt 1000000 ] ; do
  BS=$(echo $MEMAVAIL/10 | bc)
  (seq 1 10 | parallel -j0 -N0 timeout 10 nice dd if=/dev/zero of=/dev/null bs=${BS}k &)
  sleep 2;
  MEMAVAIL=$(free | perl -ane '/buffers.cache:/ and print $F[3]')
done

echo '### -N and --noswap '
niceload -H -N vmstat 1 2 | tail -n1 | awk '{print $7*$8}' &
niceload -H --noswap vmstat 1 2 | tail -n1 | awk '{print $7*$8}' &
wait

# force load > 10
while uptime | grep -v age:.[1-9][0-9].[0-9][0-9] >/dev/null ; do (timeout 5 nice burnP6 2>/dev/null &) done

echo '### --soft -f and test if child is actually suspended and thus takes longer'
niceload --soft -t 0.2 -f 0.5 'seq 1000000 | wc;echo This should finish last' &
(sleep 1; seq 1000000 | wc;echo This should finish first) &
wait

# force load > 10
while uptime | grep -v age:.[1-9][0-9].[0-9][0-9] >/dev/null ; do (timeout 5 nice burnP6 2>/dev/null &) done

echo '### -H and --hard'
niceload  -H -l 9.9 uptime | grep ':.[1-9][0-9].[0-9][0-9],' || echo OK
niceload  --hard -l 9 uptime | grep ':.[1-9][0-9].[0-9][0-9],' || echo OK

echo '### -f and --factor'
niceload -H -f 0.1 -l6 echo f 0.1 first &
niceload -H --factor 10 -l6 echo factor 10 last &
wait


#echo '### Test niceload -p'
#sleep 3 &
#nice-load -v -p $!


