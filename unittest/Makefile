unittest: ../src/parallel tests-to-run/* wanted-results/*
	echo | mop || (echo mop is required for unittest; /bin/false)
	seq 1 2 | mop || (echo seq is required for unittest; /bin/false)
	stdout echo || (echo stdout is required for unittest; /bin/false)
	convert | mop || (echo convert is required for unittest; /bin/false)
	ren 2>&1 | mop || (echo ren is required for unittest; /bin/false)
	echo | buffer | mop || (echo buffer is required for unittest; /bin/false)
	echo 1+2 | bc | mop || (echo bc is required for unittest; /bin/false)
	stdout gawk | mop || (echo gawk is required for unittest; /bin/false)
	expect -c 'spawn cat; puts "expect is installed"' || (echo expect is required for unittest; /bin/false)
	echo | pv -qL 10 || (echo pv is required for unittest; /bin/false)
	echo | script -c echo -q /dev/null || (echo script is required for unittest; /bin/false)
	time sh Start.sh
	date

clean:
	rm -rf input-files/random_dirs_no_newline
	rm -rf input-files/random_dirs_with_newline

dist:
	rm -rf input-files/random_dirs_*_newline || /bin/true
	rm -rf tmp || /bin/true
	( cd ..; tar -cvj --exclude .git --exclude '#*#' --exclude '*~' --exclude CVS -f /tmp/parallel.tar.bz2 parallel-[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9] )
	mv /tmp/parallel.tar.bz2 parallel-$$(date +"%Y%m%d").tar.bz2
	rsync -Havessh parallel-$$(date +"%Y%m%d").tar.bz2 download.savannah.nongnu.org:/releases/parallel/

