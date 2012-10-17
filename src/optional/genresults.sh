#!/bin/bash
#
# Generate the result files used to test the query modules.

../parallel --header : --result testresults/foo_ echo {a} {b} ::: a 1 2 ::: b 0.30 0.40
../parallel --header : --result testresults/bar_ echo {a} {b} ::: a 5 6 ::: b 0.70 0.80
