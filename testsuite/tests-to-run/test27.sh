#!/bin/bash -x

echo '### Tests from xargs'
# Largely untested

rsync -Ha --delete input-files/xargs-inputs/ tmp/
cd tmp

echo '### -0 -n3 echo < files0.xi'
stdout xargs -0 -n3 echo < files0.xi
stdout parallel -k -0 -n3 echo < files0.xi
echo '###  -d o -n1 echo < helloworld.xi'
stdout xargs -d o -n1 echo < helloworld.xi
stdout parallel -k -d o -n1 echo < helloworld.xi
echo '###  -E_ -0 echo < eof_-0.xi'
stdout xargs -E_ -0 echo < eof_-0.xi
stdout parallel -X -k -E_ -0 echo < eof_-0.xi
echo '###  -i -0 echo from \{\} to x{}y < items-0.xi'
stdout xargs -i -0 echo from \{\} to x{}y < items-0.xi
stdout parallel -k -i -0 echo from \{\} to x{}y < items-0.xi
echo '###  -i -s26 -0 echo from \{\} to x{}y < items-0.xi'
stdout xargs -i -s26 -0 echo from \{\} to x{}y < items-0.xi
stdout parallel -k -i -s26 -0 echo from \{\} to x{}y < items-0.xi
echo '###  -l -0 echo < ldata-0.xi'
stdout xargs -l -0 echo < ldata-0.xi
stdout parallel -l -k -0 echo < ldata-0.xi
echo '###  -l -0 echo < ldatab-0.xi'
stdout xargs -l -0 echo < ldatab-0.xi
stdout parallel -l -k -0 echo < ldatab-0.xi
echo '###  -L2 -0 echo < ldata-0.xi'
stdout xargs -L2 -0 echo < ldata-0.xi
stdout parallel -k -L2 -0 echo < ldata-0.xi
echo '###  -L2 -0 echo < ldatab-0.xi'
stdout xargs -L2 -0 echo < ldatab-0.xi
stdout parallel -k -L2 -0 echo < ldatab-0.xi
echo '###  -L3 -0 echo < ldata-0.xi'
stdout xargs -L3 -0 echo < ldata-0.xi
stdout parallel -k -L3 -0 echo < ldata-0.xi
echo '###  -n1 -0 echo < stairs-0.xi'
stdout xargs -n1 -0 echo < stairs-0.xi
stdout parallel -k -n1 -0 echo < stairs-0.xi
echo '###  -n2 -0 echo < stairs-0.xi'
stdout xargs -n2 -0 echo < stairs-0.xi
stdout parallel -k -n2 -0 echo < stairs-0.xi
echo '###  -n2 -s26 -0 echo < stairs-0.xi'
stdout xargs -n2 -s26 -0 echo < stairs-0.xi
stdout parallel -k -n2 -s26 -0 echo < stairs-0.xi
echo '###  -n2 -s26 -x -0 echo < stairs-0.xi'
stdout xargs -n2 -s26 -x -0 echo < stairs-0.xi
stdout parallel -k -n2 -s26 -x -0 echo < stairs-0.xi
echo '###  -n3 -0 echo < stairs2-0.xi'
stdout xargs -n3 -0 echo < stairs2-0.xi
stdout parallel -k -n3 -0 echo < stairs2-0.xi
stdout xargs -n3 -s36 -0 echo < stairs2-0.xi
stdout parallel -k -n3 -s36 -0 echo < stairs2-0.xi
echo '###  -0 echo < noeof-0.xi'
stdout xargs -0 echo < noeof-0.xi
stdout parallel -k -0 echo < noeof-0.xi
echo '###  -P3 -n1 -IARG sh -c ARG < Pdata.xi'
stdout xargs -P3 -n1 -IARG sh -c ARG < Pdata.xi
stdout parallel -k -P3 -n1 -IARG sh -c ARG < Pdata.xi
echo '###  -r echo this plus that < blank.xi'
stdout xargs -r echo this plus that < blank.xi
stdout parallel -k -r echo this plus that < blank.xi
echo '###  -0 -s118 echo < stairs-0.xi'
stdout xargs -0 -s118 echo < stairs-0.xi
stdout parallel -k -X -0 -s118 echo < stairs-0.xi
echo '###  -0 -s19 echo < stairs-0.xi'
stdout xargs -0 -s19 echo < stairs-0.xi
stdout parallel -k -X -0 -s19 echo < stairs-0.xi
echo '###  -0 -s19 echo < stairs2-0.xi'
stdout xargs -0 -s19 echo < stairs2-0.xi
stdout parallel -k -X -0 -s19 echo < stairs2-0.xi
echo '###  -0 -s20 echo < stairs-0.xi'
stdout xargs -0 -s20 echo < stairs-0.xi
stdout parallel -k -X -0 -s20 echo < stairs-0.xi
echo '###  -0 -s30 echo < stairs-0.xi'
stdout xargs -0 -s30 echo < stairs-0.xi
stdout parallel -k -X -0 -s30 echo < stairs-0.xi
echo '###  -0 echo this plus that < space.xi'
stdout xargs -0 echo this plus that < space.xi
stdout parallel -k -0 echo this plus that < space.xi
echo '###  -r echo this plus that < space.xi'
stdout xargs -r echo this plus that < space.xi
stdout parallel -k -r echo this plus that < space.xi
echo '###  -t -0 echo this plus that < space.xi'
stdout xargs -t -0 echo this plus that < space.xi
stdout parallel -k -t -0 echo this plus that < space.xi
echo '###  true < 32767-ys.xi'
stdout xargs true < 32767-ys.xi
stdout parallel -k true < 32767-ys.xi
echo '###  true < 16383-ys.xi'
stdout xargs true < 16383-ys.xi
stdout parallel -k true < 16383-ys.xi
echo '###  -E EOF echo < EOFb.xi'
stdout xargs -E EOF echo < EOFb.xi
stdout parallel -k -E EOF echo < EOFb.xi
echo '###  -E EOF echo < EOFe.xi'
stdout xargs -E EOF echo < EOFe.xi
stdout parallel -k -E EOF echo < EOFe.xi
echo '###  -E EOF echo < EOF.xi'
stdout xargs -E EOF echo < EOF.xi
stdout parallel -k -E EOF echo < EOF.xi
echo '###  -E_ echo < eof_.xi'
stdout xargs -E_ echo < eof_.xi
stdout parallel -k -E_ echo < eof_.xi
echo '###  -E_ -IARG echo from ARG to xARGy < eof_.xi'
stdout xargs -E_ -IARG echo from ARG to xARGy < eof_.xi
stdout parallel -k -E_ -IARG echo from ARG to xARGy < eof_.xi
echo '###  -s470 echo hi there < files.xi'
stdout xargs -s470 echo hi there < files.xi
stdout parallel -k -s470 -X echo hi there < files.xi
echo '###  -IARG echo from ARG to xARGy -E_ < eof_.xi'
stdout xargs -IARG echo from ARG to xARGy -E_ < eof_.xi
stdout parallel -k -IARG echo from ARG to xARGy -E_ < eof_.xi
echo '###  -IARG echo from ARG to xARGy < items.xi'
stdout xargs -IARG echo from ARG to xARGy < items.xi
stdout parallel -k -IARG echo from ARG to xARGy < items.xi
echo '###  -IARG -s15 echo ARG < stairs.xi'
stdout xargs -IARG -s15 echo ARG < stairs.xi
stdout parallel -k -IARG -X -s15 echo ARG < stairs.xi
echo '###  -L2 echo < ldatab.xi'
stdout xargs -L2 echo < ldatab.xi
stdout parallel -k -L2 echo < ldatab.xi
echo '###  -L2 -n2 echo < ldata.xi'
stdout xargs -L2 -n2 echo < ldata.xi
stdout parallel -k -L2 -n2 echo < ldata.xi
echo '###  -L3 echo < ldata.xi'
stdout xargs -L3 echo < ldata.xi
stdout parallel -k -L3 echo < ldata.xi
echo '###  -n1 echo < stairs.xi'
stdout xargs -n1 echo < stairs.xi
stdout parallel -k -n1 echo < stairs.xi
echo '###  -n2 echo < stairs.xi'
stdout xargs -n2 echo < stairs.xi
stdout parallel -k -n2 echo < stairs.xi
echo '###  -n2 -s26 echo < stairs.xi'
stdout xargs -n2 -s26 echo < stairs.xi
stdout parallel -k -n2 -s26 echo < stairs.xi
echo '###  -n2 -s26 -x echo < stairs.xi'
stdout xargs -n2 -s26 -x echo < stairs.xi
stdout parallel -k -n2 -s26 -x echo < stairs.xi
echo '###  -n3 echo < files.xi'
stdout xargs -n3 echo < files.xi
stdout parallel -k -n3 echo < files.xi
echo '###  -n3 -s36 echo < stairs2.xi'
stdout xargs -n3 -s36 echo < stairs2.xi
stdout parallel -k -n3 -s36 echo < stairs2.xi
echo '###  echo < noeof.xi'
stdout xargs echo < noeof.xi
stdout parallel -k echo < noeof.xi
echo '###  echo < quotes.xi'
stdout xargs echo < quotes.xi
stdout parallel -k echo < quotes.xi
echo '###  -s118 echo < stairs.xi'
stdout xargs -s118 echo < stairs.xi
stdout parallel -k -X -s118 echo < stairs.xi
echo '###  -s19 echo < stairs2.xi'
stdout xargs -s19 echo < stairs2.xi
stdout parallel -k -X -s19 echo < stairs2.xi
echo '###  -s19 echo < stairs.xi'
stdout xargs -s19 echo < stairs.xi
stdout parallel -k -X -s19 echo < stairs.xi
echo '###  -s20 echo < stairs.xi'
stdout xargs -s20 echo < stairs.xi
stdout parallel -k -X -s20 echo < stairs.xi
echo '###  -s30 echo < stairs.xi'
stdout xargs -s30 echo < stairs.xi
stdout parallel -k -X -s30 echo < stairs.xi
echo '###  -s470 echo < files.xi'
stdout xargs -s470 echo < files.xi
stdout parallel -k -X -s470 echo < files.xi
echo '###  -s47 echo < files.xi'
stdout xargs -s47 echo < files.xi
stdout parallel -k -X -s47 echo < files.xi
echo '###  -s48 echo < files.xi'
stdout xargs -s48 echo < files.xi
stdout parallel -k -X -s48 echo < files.xi
echo '###  -s6 echo < files.xi'
stdout xargs -s6 echo < files.xi
stdout parallel -k -X -s6 echo < files.xi
echo '###  -iARG -s86 echo ARG is xARGx < files.xi'
stdout xargs -iARG -s86 echo ARG is xARGx < files.xi
stdout parallel -k -iARG -s86 echo ARG is xARGx < files.xi
echo '###  echo this plus that < space.xi'
stdout xargs echo this plus that < space.xi
stdout parallel -k echo this plus that < space.xi
echo '###  -IARG echo from ARG to xARGy < space.xi'
stdout xargs -IARG echo from ARG to xARGy < space.xi
stdout parallel -k -IARG echo from ARG to xARGy < space.xi
echo '###  printf "\[%s\]\n" < verticaltabs.xi'
stdout xargs printf "\[%s\]\n" < verticaltabs.xi
stdout parallel -k printf "\[%s\]\n" < verticaltabs.xi
echo '###  printf "\[%s\]\n" < formfeeds.xi'
stdout xargs printf "\[%s\]\n" < formfeeds.xi
stdout parallel -k printf "\[%s\]\n" < formfeeds.xi
echo '###  -L2 echo < ldata.xi'
stdout xargs -L2 echo < ldata.xi
stdout parallel -k -L2 echo < ldata.xi
echo '###  echo < unmatched2.xi'
stdout xargs echo < unmatched2.xi
stdout parallel -k echo < unmatched2.xi
echo '###  echo < unmatched.xi'
stdout xargs echo < unmatched.xi
stdout parallel -k echo < unmatched.xi
echo '###  -n2 -x echo < unmatched.xi'
stdout xargs -n2 -x echo < unmatched.xi
stdout parallel -k -n2 -x echo < unmatched.xi
echo '###  -eEOF echo < eofstr.xi'
stdout xargs -eEOF echo < eofstr.xi
stdout parallel -k -eEOF echo < eofstr.xi
echo '###  -e echo < eof_.xi'
stdout xargs -e echo < eof_.xi
stdout parallel -e -k echo < eof_.xi
echo '###  -E_ echo < eof1.xi'
stdout xargs -E_ echo < eof1.xi
stdout parallel -k -E_ echo < eof1.xi
echo '###  -iARG echo ARG is xARGx < files.xi'
stdout xargs -iARG echo ARG is xARGx < files.xi
stdout parallel -k -iARG echo ARG is xARGx < files.xi
echo '###  -i echo from \{\} to x{}y < items.xi'
stdout xargs -i echo from \{\} to x{}y < items.xi
stdout parallel -k -i echo from \{\} to x{}y < items.xi
echo '###  -i -s26 echo from \{\} to x{}y < items.xi'
stdout xargs -i -s26 echo from \{\} to x{}y < items.xi
stdout parallel -k -i -s26 echo from \{\} to x{}y < items.xi
echo '###  -i__ echo FIRST __ IS OK < quotes.xi'
stdout xargs -i__ echo FIRST __ IS OK < quotes.xi
stdout parallel -k -i__ echo FIRST __ IS OK < quotes.xi
echo '###  -l echo < ldatab.xi'
stdout xargs -l echo < ldatab.xi
stdout parallel -k -l echo < ldatab.xi
echo '###  -l echo < ldata.xi'
stdout xargs -l echo < ldata.xi
stdout parallel -k -l echo < ldata.xi
echo '###  -l1 -n4 echo < files.xi'
stdout xargs -l1 -n4 echo < files.xi
stdout parallel -k -l1 -n4 echo < files.xi
echo '###  -l2 echo < files.xi'
stdout xargs -l2 echo < files.xi
stdout parallel -k -l2 echo < files.xi
echo '###  -s30 -t echo < stairs.xi - xargs'
stdout xargs -s30 -t echo < stairs.xi
echo '###  -s30 -t echo < stairs.xi - parallel'
stdout parallel -k -X -s30 -t echo < stairs.xi
echo '###  -t echo this plus that < space.xi'
stdout xargs -t echo this plus that < space.xi
stdout parallel -k -t echo this plus that < space.xi
echo '###  -n1 printf "@%s@\n" < empty.xi'
stdout xargs -n1 printf "@%s@\n" < empty.xi
stdout parallel -k -n1 printf "@%s@\n" < empty.xi
echo '###  -n2 -t echo < foobar.xi'
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
