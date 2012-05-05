#!/bin/bash

echo '### Test fix #32191'
seq 1 150 | parallel -j9 --retries 2 -S localhost,: "/bin/non-existant 2>/dev/null"
