#!/bin/bash
#
# Generate the result files used to test the query modules.

../parallel --header : --result testresults echo {a} {b} ::: a 1 2 ::: b 0.30 0.40
