#!/bin/bash

P_ALL="vax freebsd solaris openbsd netbsd debian alpha aix redhat hpux ultrix qnx irix tru64 openindiana suse openstep mandriva ubuntu scosysv unixware dragonfly centos miros hurd raspberrypi"
P_NOTWORKING="vax alpha openstep"
P_NOTWORKING_YET="ultrix irix minix"

P_WORKING="freebsd solaris openbsd netbsd debian aix redhat hpux qnx tru64 openindiana suse mandriva ubuntu scosysv unixware dragonfly centos miros hurd raspberrypi"

P="$P_WORKING"
POLAR=`parallel -k echo {}.polarhome.com ::: $P`
# Avoid the stupid /etc/issue.net banner at Polarhome

echo '### Tests on polarhome machines'
echo 'Setup on polarhome machines'
stdout parallel -kj0 ssh -oLogLevel=quiet {} mkdir -p bin ::: $POLAR &

copy_and_test() {
    H=$1
    # scp to each polarhome machine do not work. Use cat
    # Avoid the stupid /etc/issue.net banner with -oLogLevel=quiet
    echo '### Run the test on '$H
    cat `which parallel` | ssh -oLogLevel=quiet $H 'cat > bin/p.tmp && chmod 755 bin/p.tmp && mv bin/p.tmp bin/parallel; bin/perl bin/parallel echo Works on ::: '$H
}
export -f copy_and_test
stdout parallel -j0 -k --timeout 80 --delay 0.1 --tag  -v copy_and_test {} ::: $POLAR

