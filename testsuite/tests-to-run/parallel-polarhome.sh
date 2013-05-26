#!/bin/bash

P="scosysv centos dragonfly netbsd freebsd solaris openbsd debian aix hpux qnx irix suse minix openindiana mandriva unixware miros raspberrypi hurd ultrix ubuntu redhat"
P="scosysv centos dragonfly netbsd freebsd solaris openbsd debian aix hpux qnx irix suse minix openindiana mandriva unixware raspberrypi hurd ultrix ubuntu"
#P="scosysv hpux qnx irix openindiana ultrix"
POLAR=`parallel echo {}.polarhome.com ::: $P`

echo '### Tests on polarhome machines'
echo 'Setup on polarhome machines'
stdout parallel -kj0 ssh {} mkdir -p bin ::: $POLAR >/dev/null 2>/dev/null &
# scp to each polarhome machine do not work. From redhat it works.
stdout rsync -a `which parallel` redhat.polarhome.com:bin/
stdout ssh redhat.polarhome.com \
  chmod 755 bin/parallel\; \
  bin/parallel --tag -kj0 -v --delay 0.2 ssh {} rm -f bin/parallel\\\;scp bin/parallel {}:bin/ ::: $POLAR | sort
# Now test
echo 'Run the test on polarhome machines'
stdout parallel --argsep // -k --tag ssh {} bin/parallel -k echo Works on ::: {} // $POLAR | sort

