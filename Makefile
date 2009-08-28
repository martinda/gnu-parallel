parallel.1: parallel
	pod2man parallel > parallel.1

install: parallel parallel.1
	install -D -m 755 parallel $(DESTDIR)/usr/bin/parallel
	install -D -m 644 parallel.1 $(DESTDIR)/usr/share/man/man1/parallel.1

unittest: parallel unittest/tests-to-run/* unittest/wanted-results/*
	echo | mop || (echo mop is required for unittest; /bin/false)
	seq 1 2 | mop || (echo seq is required for unittest; /bin/false)
	(cd unittest; sh Start.sh)

clean:
	rm -f parallel.1

dist:
	rm -rf ./unittest/input-files/random_dirs_*_newline || /bin/true
	rm -rf ./unittest/tmp || /bin/true
	rm parallel-????????.tar.bz2 || /bin/true
	( cd ..; tar -cvj --exclude .git --exclude '#*#' --exclude '*~' --exclude CVS -f /tmp/parallel.tar.bz2 parallel-[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9] )
	mv /tmp/parallel.tar.bz2 parallel-$$(date +"%Y%m%d").tar.bz2
	rsync -Havessh parallel-$$(date +"%Y%m%d").tar.bz2 download.savannah.nongnu.org:/releases/parallel/

