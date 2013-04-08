#!/bin/bash

P="scosysv centos dragonfly netbsd freebsd solaris openbsd debian aix hpux redhat qnx irix suse minix openindiana mandriva unixware miros raspberrypi hurd ultrix ubuntu"
P="scosysv centos dragonfly netbsd freebsd solaris openbsd debian aix hpux qnx irix suse minix openindiana mandriva unixware miros raspberrypi hurd ultrix ubuntu"
#P="scosysv hpux qnx irix openindiana ultrix"
POLAR=`parallel echo {}.polarhome.com ::: $P`

echo '### Tests on polarhome machines'
parallel -j0 ssh {} mkdir -p bin ::: $POLAR 2>/dev/null &
# scp to each polarhome machine do not work. From redhat it works.
rsync -a `which parallel` redhat.polarhome.com:bin/
ssh redhat.polarhome.com \
  chmod 755 bin/parallel\; \
  bin/parallel -j0 ssh {} rm -f bin/parallel\\\;scp bin/parallel {}:bin/ ::: $POLAR
# Now test
parallel --argsep // -k --tag ssh {} bin/parallel echo Works on ::: {} // $POLAR

