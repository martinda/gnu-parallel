bin_SCRIPTS = parallel
man_MANS = parallel.1

parallel.1: parallel Makefile
	pod2man --release='$(PACKAGE_VERSION)' --center='$(PACKAGE_NAME)' \
		--section=1 $(srcdir)/parallel > $(srcdir)/parallel.1

DISTCLEANFILES = parallel.1
EXTRA_DIST = parallel parallel.1
