#!/bin/bash

echo '### Test mutex. This should take 3 seconds'
sem 'sleep 1; echo foo'
sem 'sleep 1; echo foo'
sem 'sleep 1; echo foo'
sem --wait


