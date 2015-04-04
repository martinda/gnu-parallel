#!/bin/bash

# Check servers up on http://www.polarhome.com/service/status/

P_ALL="vax freebsd solaris openbsd netbsd debian alpha aix redhat hpux ultrix minix qnx irix tru64 openindiana suse solaris-x86 mandriva ubuntu scosysv unixware dragonfly centos miros hurd raspbian macosx hpux-ia64 syllable"
P_NOTWORKING="vax alpha openstep"
P_NOTWORKING_YET="ultrix irix"

P_WORKING="minix freebsd solaris openbsd netbsd debian aix redhat hpux qnx tru64 openindiana suse solaris-x86 mandriva ubuntu scosysv unixware dragonfly centos miros hurd raspbian macosx hpux-ia64 syllable"

P="$P_WORKING"
POLAR=`parallel -k echo {}.polarhome.com ::: $P`
# Avoid the stupid /etc/issue.net banner at Polarhome: -oLogLevel=quiet

echo '### Tests on polarhome machines'
echo 'Setup on polarhome machines'
stdout parallel -kj0 ssh -oLogLevel=quiet {} mkdir -p bin ::: $POLAR &


test_empty_cmd() {
    echo '### Test if empty command in process list causes problems'
    perl -e '$0=" ";sleep 1' &
    bin/perl bin/parallel echo ::: OK_with_empty_cmd
}
export -f test_empty_cmd
stdout parallel -j0 -k --retries 5 --timeout 80 --delay 0.1 --tag \
  --nonall --env test_empty_cmd -S macosx.polarhome.com test_empty_cmd > /tmp/test_empty_cmd &

copy_and_test() {
    H=$1
    # scp to each polarhome machine do not work. Use cat
    # Avoid the stupid /etc/issue.net banner with -oLogLevel=quiet
    echo '### Run the test on '$H
    cat `which parallel` | 
      stdout ssh -oLogLevel=quiet $H 'cat > bin/p.tmp && chmod 755 bin/p.tmp && mv bin/p.tmp bin/parallel && bin/perl bin/parallel echo Works on {} ::: '$H'; bin/perl bin/parallel --tmpdir / echo ::: test read-only tmp' |
      perl -pe 's:/[a-z0-9_]+.arg:/XXXXXXXX.arg:gi; s/\d\d\d\d/0000/gi;'
}
export -f copy_and_test
stdout parallel -j0 -k --retries 5 --timeout 80 --delay 0.1 --tag  -v copy_and_test {} ::: $POLAR

cat /tmp/test_empty_cmd
rm /tmp/test_empty_cmd
