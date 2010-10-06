#!/bin/bash

PAR=parallel

# Test the empty line
echo | $PAR echo foo
