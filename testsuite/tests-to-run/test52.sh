#!/bin/bash

echo '### Test --tollef'
parallel -k --tollef echo -- 1 2 3 ::: a b c

echo '### Test --tollef --gnu'
parallel -k --tollef --gnu echo ::: 1 2 3 -- a b c

echo '### Test --gnu'
parallel -k --gnu echo ::: 1 2 3 -- a b c

echo "### test global config"
echo /etc/parallel/config | sudo parallel "mkdir -p /etc/parallel; echo --tollef > "
parallel -k echo -- 1 2 3 ::: a b c
parallel -k --gnu echo ::: 1 2 3 -- a b c
echo --gnu > ~/.parallel/config
parallel -k echo ::: 1 2 3 -- a b c
parallel -k --gnu echo ::: 1 2 3 -- a b c
sudo rm /etc/parallel/config
rm ~/.parallel/config
