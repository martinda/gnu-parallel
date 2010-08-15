bin_SCRIPTS = parallel sem
man_MANS = parallel.1 sem.1
doc_DATA = parallel.html sem.html

parallel.1: parallel Makefile
	pod2man --release='$(PACKAGE_VERSION)' --center='$(PACKAGE_NAME)' \
		--section=1 $(srcdir)/parallel > $(srcdir)/parallel.1

sem.1: sem Makefile
	pod2man --release='$(PACKAGE_VERSION)' --center='$(PACKAGE_NAME)' \
		--section=1 $(srcdir)/sem > $(srcdir)/sem.1

parallel.html: parallel Makefile
	pod2html $(srcdir)/parallel > $(srcdir)/parallel.html
	rm $(srcdir)/pod2htm*

sem.html: sem Makefile
	pod2html $(srcdir)/sem > $(srcdir)/sem.html
	rm $(srcdir)/pod2htm*

DISTCLEANFILES = parallel.1 sem.1 parallel.html sem.html
EXTRA_DIST = parallel sem parallel.1 sem.1 parallel.html sem.html
