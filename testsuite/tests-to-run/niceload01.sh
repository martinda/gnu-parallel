#!/bin/bash

echo '### Test niceload'
niceload -s 1 perl -e '$|=1;do{$l==$r or print "."; $l=$r}until(($r=time-$^T)>10)'
echo 

echo '### -f and --factor'
niceload -f 0.1 echo f 0.1
niceload --factor 0.1 echo factor 0.1

echo '### -f and --factor'
niceload -f 0.1 echo f 0.1
niceload --factor 0.1 echo factor 0.1

# Force less than 1 GB buffer+cache
MEMAVAIL=$(free | perl -ane '/buffers.cache:/ and print $F[3]')
while [ $MEMAVAIL -gt 1000000 ] ; do
  BS=$(echo $MEMAVAIL/10 | bc)
  (seq 1 5 | parallel -j0 -N0 timeout 10 nice dd if=/dev/zero of=/dev/null bs=${BS}k &)
  sleep 2;
  MEMAVAIL=$(free | perl -ane '/buffers.cache:/ and print $F[3]')
  echo $MEMAVAIL
done
# free
echo '### --rm and --runmem'
niceload  -H --rm 1g free -g | perl -ane '/buffers.cache:/ and print $F[3],"\n"' | grep '[1-9]' >/dev/null && echo OK &
niceload  -H --runmem 1.2g free -g | perl -ane '/buffers.cache:/ and print $F[3],"\n"' | grep '[1-9]' >/dev/null && echo OK &
wait
# free

# Force swapping
MEMAVAIL=$(free | perl -ane '/buffers.cache:/ and print $F[3]')
while [ $MEMAVAIL -gt 1000000 ] ; do
  BS=$(echo $MEMAVAIL/10 | bc)
  (seq 1 10 | parallel -j0 -N0 timeout 10 nice dd if=/dev/zero of=/dev/null bs=${BS}k &)
  sleep 2;
  MEMAVAIL=$(free | perl -ane '/buffers.cache:/ and print $F[3]')
  echo $MEMAVAIL
done

echo '### -N and --noswap '
niceload -D -H -N vmstat 1 2 | tail -n1 | awk '{print $7*$8}' &
niceload -D -H --noswap vmstat 1 2 | tail -n1 | awk '{print $7*$8}' &
wait


# force load > 10
while uptime | grep -v '[1-9][0-9]\.[0-9][0-9],' >/dev/null ; do (timeout 2 nice burnP6 2>/dev/null &) done

echo '### -H and --hard'
niceload  -H -l 9.9 uptime | grep '[1-9][0-9]\.[0-9][0-9],' || echo OK
niceload  --hard -l 9 uptime | grep '[1-9][0-9]\.[0-9][0-9],' || echo OK


#echo '### Test niceload -p'
#sleep 3 &
#nice-load -v -p $!


