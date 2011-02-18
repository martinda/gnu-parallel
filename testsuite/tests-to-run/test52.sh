#!/bin/bash

echo '### Test --tollef'
parallel --tollef echo -- 1 2 3

echo '### Test --tollef --gnu'
parallel --tollef --gnu echo ::: 1 2 3

echo '### Test --gnu'
parallel --gnu echo ::: 1 2 3
