#!/bin/bash -x

echo '### Tests from xargs'
# Largely untested

rsync -Ha --delete input-files/xargs-inputs/ tmp/
cd tmp

stdout xargs -0 -n3 echo < files0.xi
stdout parallel -k -0 -n3 echo < files0.xi
stdout xargs -d o -n1 echo < helloworld.xi
stdout parallel -k -d o -n1 echo < helloworld.xi
stdout xargs -E_ -0 echo < eof_-0.xi
stdout parallel -k -E_ -0 echo < eof_-0.xi
stdout xargs -i -0 echo from \{\} to x{}y < items-0.xi
stdout parallel -k -i -0 echo from \{\} to x{}y < items-0.xi
stdout xargs -i -s26 -0 echo from \{\} to x{}y < items-0.xi
stdout parallel -k -i -s26 -0 echo from \{\} to x{}y < items-0.xi
stdout xargs -l -0 echo < ldata-0.xi
stdout parallel -k -l -0 echo < ldata-0.xi
stdout xargs -l -0 echo < ldatab-0.xi
stdout parallel -k -l -0 echo < ldatab-0.xi
stdout xargs -L2 -0 echo < ldata-0.xi
stdout parallel -k -L2 -0 echo < ldata-0.xi
stdout xargs -L2 -0 echo < ldatab-0.xi
stdout parallel -k -L2 -0 echo < ldatab-0.xi
stdout xargs -L3 -0 echo < ldata-0.xi
stdout parallel -k -L3 -0 echo < ldata-0.xi
stdout xargs -n1 -0 echo < stairs-0.xi
stdout parallel -k -n1 -0 echo < stairs-0.xi
stdout xargs -n2 -0 echo < stairs-0.xi
stdout parallel -k -n2 -0 echo < stairs-0.xi
stdout xargs -n2 -s26 -0 echo < stairs-0.xi
stdout parallel -k -n2 -s26 -0 echo < stairs-0.xi
stdout xargs -n2 -s26 -x -0 echo < stairs-0.xi
stdout parallel -k -n2 -s26 -x -0 echo < stairs-0.xi
stdout xargs -n3 -0 echo < stairs2-0.xi
stdout parallel -k -n3 -0 echo < stairs2-0.xi
stdout xargs -n3 -s36 -0 echo < stairs2-0.xi
stdout parallel -k -n3 -s36 -0 echo < stairs2-0.xi
stdout xargs -0 echo < noeof-0.xi
stdout parallel -k -0 echo < noeof-0.xi
stdout xargs -P3 -n1 -IARG sh -c ARG < Pdata.xi
stdout parallel -k -P3 -n1 -IARG sh -c ARG < Pdata.xi
stdout xargs -r echo this plus that < blank.xi
stdout parallel -k -r echo this plus that < blank.xi
stdout xargs -0 -s118 echo < stairs-0.xi
stdout parallel -k -0 -s118 echo < stairs-0.xi
stdout xargs -0 -s19 echo < stairs-0.xi
stdout parallel -k -0 -s19 echo < stairs-0.xi
stdout xargs -0 -s19 echo < stairs2-0.xi
stdout parallel -k -0 -s19 echo < stairs2-0.xi
stdout xargs -0 -s20 echo < stairs-0.xi
stdout parallel -k -0 -s20 echo < stairs-0.xi
stdout xargs -0 -s30 echo < stairs-0.xi
stdout parallel -k -0 -s30 echo < stairs-0.xi
stdout xargs -0 echo this plus that < space.xi
stdout parallel -k -0 echo this plus that < space.xi
stdout xargs -r echo this plus that < space.xi
stdout parallel -k -r echo this plus that < space.xi
stdout xargs -t -0 echo this plus that < space.xi
stdout parallel -k -t -0 echo this plus that < space.xi
stdout xargs true < 32767-ys.xi
stdout parallel -k true < 32767-ys.xi
stdout xargs true < 16383-ys.xi
stdout parallel -k true < 16383-ys.xi
stdout xargs -E EOF echo < EOFb.xi
stdout parallel -k -E EOF echo < EOFb.xi
stdout xargs -E EOF echo < EOFe.xi
stdout parallel -k -E EOF echo < EOFe.xi
stdout xargs -E EOF echo < EOF.xi
stdout parallel -k -E EOF echo < EOF.xi
stdout xargs -E_ echo < eof_.xi
stdout parallel -k -E_ echo < eof_.xi
stdout xargs -E_ -IARG echo from ARG to xARGy < eof_.xi
stdout parallel -k -E_ -IARG echo from ARG to xARGy < eof_.xi
stdout xargs -s470 echo hi there < files.xi
stdout parallel -k -s470 echo hi there < files.xi
stdout xargs -IARG echo from ARG to xARGy -E_ < eof_.xi
stdout parallel -k -IARG echo from ARG to xARGy -E_ < eof_.xi
stdout xargs -IARG echo from ARG to xARGy < items.xi
stdout parallel -k -IARG echo from ARG to xARGy < items.xi
stdout xargs -IARG -s15 echo ARG < stairs.xi
stdout parallel -k -IARG -s15 echo ARG < stairs.xi
stdout xargs -L2 echo < ldatab.xi
stdout parallel -k -L2 echo < ldatab.xi
stdout xargs -L2 -n2 echo < ldata.xi
stdout parallel -k -L2 -n2 echo < ldata.xi
stdout xargs -L3 echo < ldata.xi
stdout parallel -k -L3 echo < ldata.xi
stdout xargs -n1 < stairs.xi
stdout parallel -k -n1 echo < stairs.xi
stdout xargs -n2 echo < stairs.xi
stdout parallel -k -n2 echo < stairs.xi
stdout xargs -n2 -s26 echo < stairs.xi
stdout parallel -k -n2 -s26 echo < stairs.xi
stdout xargs -n2 -s26 -x echo < stairs.xi
stdout parallel -k -n2 -s26 -x echo < stairs.xi
stdout xargs -n3 echo < files.xi
stdout parallel -k -n3 echo < files.xi
stdout xargs -n3 -s36 echo < stairs2.xi
stdout parallel -k -n3 -s36 echo < stairs2.xi
stdout xargs echo < noeof.xi
stdout parallel -k echo < noeof.xi
stdout xargs echo < quotes.xi
stdout parallel -k echo < quotes.xi
stdout xargs -s118 echo < stairs.xi
stdout parallel -k -s118 echo < stairs.xi
stdout xargs -s19 echo < stairs2.xi
stdout parallel -k -s19 echo < stairs2.xi
stdout xargs -s19 echo < stairs.xi
stdout parallel -k -s19 echo < stairs.xi
stdout xargs -s20 echo < stairs.xi
stdout parallel -k -s20 echo < stairs.xi
stdout xargs -s30 echo < stairs.xi
stdout parallel -k -s30 echo < stairs.xi
stdout xargs -s470 echo < files.xi
stdout parallel -k -s470 echo < files.xi
stdout xargs -s47 echo < files.xi
stdout parallel -k -s47 echo < files.xi
stdout xargs -s48 echo < files.xi
stdout parallel -k -s48 echo < files.xi
stdout xargs -s6 echo < files.xi
stdout parallel -k -s6 echo < files.xi
stdout xargs -iARG -s86 echo ARG is xARGx < files.xi
stdout parallel -k -iARG -s86 echo ARG is xARGx < files.xi
stdout xargs echo this plus that < space.xi
stdout parallel -k echo this plus that < space.xi
stdout xargs -IARG echo from ARG to xARGy < space.xi
stdout parallel -k -IARG echo from ARG to xARGy < space.xi
stdout xargs printf "\[%s\]\n" < verticaltabs.xi
stdout parallel -k printf "\[%s\]\n" < verticaltabs.xi
stdout xargs printf "\[%s\]\n" < formfeeds.xi
stdout parallel -k printf "\[%s\]\n" < formfeeds.xi
stdout xargs -L2 echo < ldata.xi
stdout parallel -k -L2 echo < ldata.xi
stdout xargs echo < unmatched2.xi
stdout parallel -k echo < unmatched2.xi
stdout xargs echo < unmatched.xi
stdout parallel -k echo < unmatched.xi
stdout xargs -n2 -x < unmatched.xi
stdout parallel -k -n2 -x < unmatched.xi
stdout xargs -eEOF < eofstr.xi
stdout parallel -k -eEOF < eofstr.xi
stdout xargs -e < eof_.xi
stdout parallel -k -e < eof_.xi
stdout xargs -E_ < eof1.xi
stdout parallel -k -E_ < eof1.xi
stdout xargs -iARG echo ARG is xARGx < files.xi
stdout parallel -k -iARG echo ARG is xARGx < files.xi
stdout xargs -i echo from \{\} to x{}y < items.xi
stdout parallel -k -i echo from \{\} to x{}y < items.xi
stdout xargs -i -s26 echo from \{\} to x{}y < items.xi
stdout parallel -k -i -s26 echo from \{\} to x{}y < items.xi
stdout xargs -i__ echo FIRST __ IS OK < quotes.xi
stdout parallel -k -i__ echo FIRST __ IS OK < quotes.xi
stdout xargs -l < ldatab.xi
stdout parallel -k -l < ldatab.xi
stdout xargs -l < ldata.xi
stdout parallel -k -l < ldata.xi
stdout xargs -l1 -n4 < files.xi
stdout parallel -k -l1 -n4 < files.xi
stdout xargs -l2 < files.xi
stdout parallel -k -l2 < files.xi
stdout xargs -s30 -t < stairs.xi
stdout parallel -k -s30 -t < stairs.xi
stdout xargs -t echo this plus that < space.xi
stdout parallel -k -t echo this plus that < space.xi
stdout xargs -n1 printf "@%s@\n" < empty.xi
stdout parallel -k -n1 printf "@%s@\n" < empty.xi
stdout xargs -n2 -t echo < foobar.xi
stdout parallel -k -n2 -t echo < foobar.xi

# 
# xargs_start 123 {-n1 -IARG sh -c ARG} ftt.xi
# xargs_start 124 {-n1 -IARG sh -c ARG} ett.xi
# xargs_start 125 {-n1 -IARG sh -c ARG} stt.xi
# xargs_start 123 { false } files.xi
# xargs_start p {-t echo this plus that}
# xargs_start p "" sv-bug-20273.xi "" "sh -c \{$XARGS $XARGSFLAGS -E2; cat\}"
# xargs_start p {echo this plus that}
# xargs_start p {}
# xargs_start p {-r}
# xargs_start p {-r echo this plus that}
# xargs_start p {echo this plus that} {}
# xargs_start p {-t}
