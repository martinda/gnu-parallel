#!/bin/bash

echo "### Test : as delimiter. This can be confusing for uptime ie. --load";
parallel -k --load 300% -d : echo ::: a:b:c

export PARALLEL="--load 300%"
echo PARALLEL=$PARALLEL

for i in $(seq 2 10); do
  i2=$[i*i]
  seq $i2 | parallel -j0 --load 300% -kX echo {} | wc
  seq 1 ${i2}0000 | nice parallel -kj20 --recend "\n" --spreadstdin gzip -1 | zcat | sort -n | md5sum
done

echo "### Test if --load blocks. Bug.";
  seq 1 1000 | parallel -kj2 --load 300% --recend "\n" --spreadstdin gzip -1 | zcat | sort -n | md5sum
  seq 1 1000 | parallel -kj240 --load 300% --recend "\n" --spreadstdin gzip -1 | zcat | sort -n | md5sum

echo "### Test reading load from PARALLEL"
  seq 1 1000000 | parallel -kj240 --recend "\n" --spreadstdin gzip -1 | zcat | sort -n | md5sum
  seq 1 1000000 | parallel -kj20 --recend "\n" --spreadstdin gzip -1 | zcat | sort -n | md5sum
