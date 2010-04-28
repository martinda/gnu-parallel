bin_SCRIPTS = parallel
man_MANS = parallel.1
doc_DATA = parallel.html

parallel.1: parallel Makefile
	pod2man --release='$(PACKAGE_VERSION)' --center='$(PACKAGE_NAME)' \
		--section=1 $(srcdir)/parallel > $(srcdir)/parallel.1

parallel.html: parallel Makefile
	pod2html $(srcdir)/parallel > $(srcdir)/parallel.html
	rm $(srcdir)/pod2htm*

DISTCLEANFILES = parallel.1 parallel.html
EXTRA_DIST = parallel parallel.1 parallel.html
