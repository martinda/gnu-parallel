bin_SCRIPTS = parallel sem sql
man_MANS = parallel.1 sem.1 sql.1
doc_DATA = parallel.html sem.html sql.html

parallel.1: parallel Makefile
	pod2man --release='$(PACKAGE_VERSION)' --center='$(PACKAGE_NAME)' \
		--section=1 $(srcdir)/parallel > $(srcdir)/parallel.1

sem.1: sem.pod Makefile
	pod2man --release='$(PACKAGE_VERSION)' --center='$(PACKAGE_NAME)' \
		--section=1 $(srcdir)/sem.pod > $(srcdir)/sem.1

sql.1: sql Makefile
	pod2man --release='$(PACKAGE_VERSION)' --center='$(PACKAGE_NAME)' \
		--section=1 $(srcdir)/sql > $(srcdir)/sql.1

parallel.html: parallel Makefile
	pod2html $(srcdir)/parallel > $(srcdir)/parallel.html
	rm -f $(srcdir)/pod2htm*

sem.html: sem.pod Makefile
	pod2html $(srcdir)/sem.pod > $(srcdir)/sem.html
	rm -f $(srcdir)/pod2htm*

sql.html: sql Makefile
	pod2html $(srcdir)/sql > $(srcdir)/sql.html
	rm -f $(srcdir)/pod2htm*

sem: parallel
	ln -fs parallel sem

DISTCLEANFILES = parallel.1 sem.1 sql.1 parallel.html sem.html sql.html
EXTRA_DIST = parallel sem sql parallel.1 sem.1 sql.1 parallel.html sem.html sem.pod sql.html
