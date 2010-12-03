#!/bin/bash


# Test --nice
echo '### Test --nice locally'
parallel --nice 1 -vv 'PAR=a bash -c "echo  \$PAR {}"' ::: b

echo '### Test --nice remote'
parallel --nice 1 -S .. -vv 'PAR=a bash -c "echo  \$PAR {}"' ::: b
