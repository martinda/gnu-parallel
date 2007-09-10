parallel.1: parallel
	pod2man parallel > parallel.1

install: parallel parallel.1
	cp parallel /usr/local/bin/parallel
	cp parallel.1 /usr/local/man/man1/parallel.1

unittest: parallel unittest/tests-to-run/* unittest/wanted-results/*
	(cd unittest; sh Start.sh)

dist:
	rm -rf ./unittest/input-files/random_dirs_*_newline || /bin/true
	rm -rf ./unittest/tmp || /bin/true
	rm parallel.tar.bz2 || /bin/true
	( cd ..; tar -cvj --exclude .git --exclude '#*#' --exclude '*~' --exclude CVS -f /tmp/parallel.tar.bz2 parallel )
	mv /tmp/parallel.tar.bz2 .