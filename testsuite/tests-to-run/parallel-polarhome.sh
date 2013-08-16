#!/bin/bash

P_ALL="vax freebsd solaris openbsd netbsd debian alpha aix redhat hpux ultrix qnx irix tru64 openindiana suse openstep mandriva ubuntu scosysv unixware dragonfly centos miros hurd minix raspberrypi"
P_NOTWORKING="vax alpha openstep"
P_NOTWORKING_YET="ultrix tru64 irix"

P_WORKING="freebsd solaris openbsd netbsd debian aix redhat hpux qnx openindiana suse mandriva ubuntu scosysv unixware dragonfly centos miros hurd minix raspberrypi"

P="$P_WORKING"
POLAR=`parallel -k echo {}.polarhome.com ::: $P`
# Avoid the stupid /etc/issue.net banner at Polarhome

echo '### Tests on polarhome machines'
echo 'Setup on polarhome machines'
stdout parallel -kj0 ssh -oLogLevel=quiet {} mkdir -p bin ::: $POLAR &
# scp to each polarhome machine do not work. Use cat
copy_to_host() {
    H=$1
    # Avoid the stupid /etc/issue.net banner with -oLogLevel=quiet
    ssh -oLogLevel=quiet $H rm -f bin/parallel
    cat `which parallel` | ssh -oLogLevel=quiet $H 'cat > bin/parallel; chmod 755 bin/parallel'
}
export -f copy_to_host
stdout parallel -j0 --timeout 20 --tag -kj0 -v copy_to_host {} ::: $POLAR
# Now test
echo '### Run the test on polarhome machines'
stdout parallel -j0 --argsep // -k --tag ssh -oLogLevel=quiet {} bin/perl bin/parallel -k echo Works on ::: {} // $POLAR


