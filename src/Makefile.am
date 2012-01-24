bin_SCRIPTS = parallel sem sql niceload
man_MANS = parallel.1 sem.1 sql.1 niceload.1
doc_DATA = parallel.html sem.html sql.html niceload.html parallel.texi sem.texi sql.texi niceload.texi

parallel.1: parallel.pod Makefile
	pod2man --release='$(PACKAGE_VERSION)' --center='$(PACKAGE_NAME)' \
		--section=1 $(srcdir)/parallel.pod > $(srcdir)/parallel.1

sem.1: sem.pod Makefile
	pod2man --release='$(PACKAGE_VERSION)' --center='$(PACKAGE_NAME)' \
		--section=1 $(srcdir)/sem.pod > $(srcdir)/sem.1

sql.1: sql Makefile
	pod2man --release='$(PACKAGE_VERSION)' --center='$(PACKAGE_NAME)' \
		--section=1 $(srcdir)/sql > $(srcdir)/sql.1

niceload.1: niceload.pod Makefile
	pod2man --release='$(PACKAGE_VERSION)' --center='$(PACKAGE_NAME)' \
		--section=1 $(srcdir)/niceload.pod > $(srcdir)/niceload.1

parallel.html: parallel.pod Makefile
	pod2html $(srcdir)/parallel.pod > $(srcdir)/parallel.html
	rm -f $(srcdir)/pod2htm*

# Depending on parallel.html to avoid stupid pod2html race condition
sem.html: sem.pod Makefile parallel.html
	pod2html $(srcdir)/sem.pod > $(srcdir)/sem.html
	rm -f $(srcdir)/pod2htm*

# Depending on sem.html to avoid stupid pod2html race condition
sql.html: sql Makefile sem.html
	pod2html $(srcdir)/sql > $(srcdir)/sql.html
	rm -f $(srcdir)/pod2htm*

# Depending on sql.html to avoid stupid pod2html race condition
niceload.html: niceload.pod Makefile sql.html
	pod2html $(srcdir)/niceload.pod > $(srcdir)/niceload.html
	rm -f $(srcdir)/pod2htm*

parallel.texi: parallel.pod
	pod2texi --output=$(srcdir)/parallel.texi $(srcdir)/parallel.pod

sem.texi: sem.pod
	pod2texi --output=$(srcdir)/sem.texi $(srcdir)/sem.pod

sql.texi: sql
	pod2texi --output=$(srcdir)/sql.texi $(srcdir)/sql

niceload.texi: niceload.pod
	pod2texi --output=$(srcdir)/niceload.texi $(srcdir)/niceload.pod

sem: parallel
	ln -fs parallel sem

DISTCLEANFILES = parallel.html sem.html sql.html niceload.html
EXTRA_DIST = parallel sem sql niceload \
	parallel.1 sem.1 sql.1 niceload.1 \
	parallel.html sem.html sql.html niceload.html \
	sem.pod parallel.pod niceload.pod
