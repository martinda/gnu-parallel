testsuite: 3
	true

3: ../src/parallel tests-to-run/* wanted-results/* startdb prereqlocal prereqremote
	TRIES=3 time sh Start.sh || true
	touch ~/.parallel/will-cite
	date
	make stopvm

1: ../src/parallel tests-to-run/* wanted-results/* prereqlocal startdb prereqremote
	time sh Start.sh || true
	touch ~/.parallel/will-cite
	date
	make stopvm

testdb: ../src/parallel tests-to-run/*sql* wanted-results/*sql* prereqdb
	time sh Start.sh sql
	date

local:	testlocal
	true

testlocal: ../src/parallel tests-to-run/*local* wanted-results/*local* prereqlocal installparallel
	time sh Start.sh local
	date

prereqlocal: installparallel
	tcsh -c echo tcsh installed || (echo tcsh is required for testsuite; /bin/false)
	seq 1 2 >/dev/null || (echo seq is required for testsuite; /bin/false)
	stdout echo || (echo stdout is required for testsuite; /bin/false)
	convert >/dev/null || (echo convert is required for testsuite; /bin/false)
	echo 1+2 | bc >/dev/null || (echo bc is required for testsuite; /bin/false)
	echo | gawk '{print "gawk is installed"}' || (echo gawk is required for testsuite; /bin/false)
	expect -c 'spawn cat; puts "expect is installed"' || (echo expect is required for testsuite; /bin/false)
	echo | pv -qL 10 || (echo pv is required for testsuite; /bin/false)
	echo | script -c echo -q /dev/null || (echo script is required for testsuite; /bin/false)
	niceload true || (echo niceload is required for testsuite; /bin/false)
	which burnP6 || (echo burnP6 is required for testsuite; /bin/false)
	which timeout || (echo timeout is required for testsuite; /bin/false)

prereqremote: installparallel startvm
	parallel --tag ssh parallel@parallel-server{} parallel --minversion 20121021 ::: 1 2 3 || (echo parallel on remote required for testsuite; /bin/true)

startvm:
	# Make sure we can reach the virtual machines
	sudo ifconfig wlan0:0 192.168.1.72
	# If they are already running: Don't fail
	VBoxManage startvm CentOS3-root:centos3 || true
	VBoxManage startvm RedHat9-root:redhat9 || true

stopvm:
	VBoxManage controlvm CentOS3-root:centos3 savestate
	VBoxManage controlvm RedHat9-root:redhat9 savestate
	VBoxManage controlvm OracleXE savestate

installparallel: ../src/parallel
	cd .. && make -j && sudo make -j install

startdb:
	#echo shutdown abort | sudo su - oracle -c "sqlplus / as sysdba"
	sudo parallel /etc/init.d/{} restart ::: postgresql mysql # oracle-xe
	VBoxManage startvm OracleXE || true

clean:
	rm -rf input-files/random_dirs_no_newline
	rm -rf input-files/random_dirs_with_newline

dist:
	rm -rf input-files/random_dirs_*_newline || /bin/true
	rm -rf tmp || /bin/true
	( cd ..; tar -cvj --exclude .git --exclude '#*#' --exclude '*~' --exclude CVS -f /tmp/parallel.tar.bz2 parallel-[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9] )
	mv /tmp/parallel.tar.bz2 parallel-$$(date +"%Y%m%d").tar.bz2
	rsync -Havessh parallel-$$(date +"%Y%m%d").tar.bz2 download.savannah.nongnu.org:/releases/parallel/

portable:
	# Cache sudo password
	sudo echo
	time bash Portable.sh

timings: tests-to-run/* ../src/parallel
	ls tests-to-run/*.sh | parallel echo /usr/bin/time -f %e bash >/tmp/timing.script
	stdout bash -x /tmp/timing.script | tee /tmp/timing.out
	echo usr.bin.time_END >>/tmp/timing.out
	perl -ne '/usr.bin.time/ and do { print $$last.$$h; $$h=$$_ }; chomp; $$last = $$_' /tmp/timing.out | sort -n >timings
