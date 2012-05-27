testsuite: ../src/parallel tests-to-run/* wanted-results/* startdb prereq
	time sh Start.sh
	date

local: ../src/parallel tests-to-run/*local* wanted-results/*local* startdb prereq
	time sh Start.sh local
	date

prereq: installparallel
	echo | mop || (echo mop is required for testsuite; /bin/false)
	seq 1 2 | mop || (echo seq is required for testsuite; /bin/false)
	stdout echo || (echo stdout is required for testsuite; /bin/false)
	convert | mop || (echo convert is required for testsuite; /bin/false)
	ren 2>&1 | mop || (echo ren is required for testsuite; /bin/false)
	echo | buffer | mop || (echo buffer is required for testsuite; /bin/false)
	echo 1+2 | bc | mop || (echo bc is required for testsuite; /bin/false)
	stdout gawk | mop || (echo gawk is required for testsuite; /bin/false)
	expect -c 'spawn cat; puts "expect is installed"' || (echo expect is required for testsuite; /bin/false)
	echo | pv -qL 10 || (echo pv is required for testsuite; /bin/false)
	echo | script -c echo -q /dev/null || (echo script is required for testsuite; /bin/false)
	niceload true || (echo niceload is required for testsuite; /bin/false)
	which burnP6 || (echo burnP6 is required for testsuite; /bin/false)
	which timeout || (echo timeout is required for testsuite; /bin/false)
	parallel ssh parallel@parallel-server{} parallel --minversion 20100101 ::: 1 2 3 || (echo parallel on remote required for testsuite; /bin/true)

installparallel: ../src/parallel
	cd .. && make -j && sudo make -j install

startdb:
	sudo parallel /etc/init.d/{} start ::: postgresql mysql oracle-xe

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
	ls tests-to-run/*.sh | xargs -n1 echo /usr/bin/time -f %e bash >/tmp/timing.script
	stdout bash -x /tmp/timing.script >/tmp/timing.out
	echo usr.bin.time_END >>/tmp/timing.out
	perl -ne '/usr.bin.time/ and do { print $$last.$$h; $$h=$$_ }; chomp; $$last = $$_' /tmp/timing.out | sort -n >timings
