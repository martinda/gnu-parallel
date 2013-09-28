#!/bin/bash

echo "### test global config - must run alone so the global config does not confuse others"
  echo /etc/parallel/config | sudo parallel "mkdir -p /etc/parallel; echo --tollef > "
  stdout parallel -k echo -- 1 2 3 ::: a b c
  stdout parallel -k --gnu echo ::: 1 2 3 -- a b c
  echo --gnu > ~/.parallel/config
  parallel -k echo ::: 1 2 3 -- a b c
  parallel -k --gnu echo ::: 1 2 3 -- a b c
  sudo rm /etc/parallel/config
  rm ~/.parallel/config
echo "<<< End test global config - must run alone so the global config does not confuse others"
