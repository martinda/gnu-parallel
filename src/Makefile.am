bin_SCRIPTS = parallel
man_MANS = parallel.1

parallel.1: parallel Makefile
	pod2man --release='$(PACKAGE_VERSION)' --center='$(PACKAGE_NAME)' \
		--section=1 parallel > parallel.1

CLEANFILES = parallel.1
