bin_SCRIPTS = parallel sem sql niceload
man_MANS = parallel.1 sem.1 sql.1 niceload.1 parallel_tutorial.1
doc_DATA = parallel.html sem.html sql.html niceload.html parallel_tutorial.html parallel.texi sem.texi sql.texi niceload.texi parallel_tutorial.texi parallel.pdf sem.pdf sql.pdf niceload.pdf parallel_tutorial.pdf

parallel.1: parallel.pod Makefile
	pod2man --release='$(PACKAGE_VERSION)' --center='$(PACKAGE_NAME)' \
		--section=1 $(srcdir)/parallel.pod > $(srcdir)/parallel.1 \
	|| echo "Warning: pod2man not found. Using old parallel.1"

parallel_tutorial.1: parallel_tutorial.pod Makefile
	pod2man --release='$(PACKAGE_VERSION)' --center='$(PACKAGE_NAME)' \
		--section=1 $(srcdir)/parallel_tutorial.pod > $(srcdir)/parallel_tutorial.1 \
	|| echo "Warning: pod2man not found. Using old parallel_tutorial.1"

sem.1: sem.pod Makefile
	pod2man --release='$(PACKAGE_VERSION)' --center='$(PACKAGE_NAME)' \
		--section=1 $(srcdir)/sem.pod > $(srcdir)/sem.1 \
	|| echo "Warning: pod2man not found. Using old sem.1"

sql.1: sql Makefile
	pod2man --release='$(PACKAGE_VERSION)' --center='$(PACKAGE_NAME)' \
		--section=1 $(srcdir)/sql > $(srcdir)/sql.1 \
	|| echo "Warning: pod2man not found. Using old sql.1"

niceload.1: niceload.pod Makefile
	pod2man --release='$(PACKAGE_VERSION)' --center='$(PACKAGE_NAME)' \
		--section=1 $(srcdir)/niceload.pod > $(srcdir)/niceload.1 \
	|| echo "Warning: pod2man not found. Using old niceload.1"

parallel.html: parallel.pod Makefile
	pod2html $(srcdir)/parallel.pod > $(srcdir)/parallel.html \
	|| echo "Warning: pod2html not found. Using old parallel.html"
	rm -f $(srcdir)/pod2htm*

# Depending on parallel.html to avoid stupid pod2html race condition
parallel_tutorial.html: parallel_tutorial.pod Makefile parallel.html
	pod2html $(srcdir)/parallel_tutorial.pod > $(srcdir)/parallel_tutorial.html \
	|| echo "Warning: pod2html not found. Using old parallel_tutorial.html"
	rm -f $(srcdir)/pod2htm*

# Depending on parallel_tutorial.html to avoid stupid pod2html race condition
sem.html: sem.pod Makefile parallel_tutorial.html
	pod2html $(srcdir)/sem.pod > $(srcdir)/sem.html \
	|| echo "Warning: pod2html not found. Using old sem.html"
	rm -f $(srcdir)/pod2htm*

# Depending on sem.html to avoid stupid pod2html race condition
sql.html: sql Makefile sem.html
	pod2html $(srcdir)/sql > $(srcdir)/sql.html \
	|| echo "Warning: pod2html not found. Using old sql.html"
	rm -f $(srcdir)/pod2htm*

# Depending on sql.html to avoid stupid pod2html race condition
niceload.html: niceload.pod Makefile sql.html
	pod2html $(srcdir)/niceload.pod > $(srcdir)/niceload.html \
	|| echo "Warning: pod2html not found. Using old niceload.html"
	rm -f $(srcdir)/pod2htm*

parallel.texi: parallel.pod
	pod2texi --output=$(srcdir)/parallel.texi $(srcdir)/parallel.pod \
	|| echo "Warning: pod2texi not found. Using old parallel.texi"

parallel_tutorial.texi: parallel_tutorial.pod
	pod2texi --output=$(srcdir)/parallel_tutorial.texi $(srcdir)/parallel_tutorial.pod \
	|| echo "Warning: pod2texi not found. Using old parallel_tutorial.texi"

sem.texi: sem.pod
	pod2texi --output=$(srcdir)/sem.texi $(srcdir)/sem.pod \
	|| echo "Warning: pod2texi not found. Using old sem.texi"

sql.texi: sql
	pod2texi --output=$(srcdir)/sql.texi $(srcdir)/sql \
	|| echo "Warning: pod2texi not found. Using old sql.texi"

niceload.texi: niceload.pod
	pod2texi --output=$(srcdir)/niceload.texi $(srcdir)/niceload.pod \
	|| echo "Warning: pod2texi not found. Using old niceload.texi"

parallel.pdf: parallel.pod
	pod2pdf --output-file $(srcdir)/parallel.pdf $(srcdir)/parallel.pod --title "GNU Parallel" \
	|| echo "Warning: pod2pdf not found. Using old parallel.pdf"

parallel_tutorial.pdf: parallel_tutorial.pod
	pod2pdf --output-file $(srcdir)/parallel_tutorial.pdf $(srcdir)/parallel_tutorial.pod --title "GNU Parallel Tutorial" \
	|| echo "Warning: pod2pdf not found. Using old parallel_tutorial.pdf"

sem.pdf: sem.pod
	pod2pdf --output-file $(srcdir)/sem.pdf $(srcdir)/sem.pod --title "GNU sem" \
	|| echo "Warning: pod2pdf not found. Using old sem.pdf"

sql.pdf: sql
	pod2pdf --output-file $(srcdir)/sql.pdf $(srcdir)/sql --title "GNU SQL" \
	|| echo "Warning: pod2pdf not found. Using old sql.pdf"

niceload.pdf: niceload.pod
	pod2pdf --output-file $(srcdir)/niceload.pdf $(srcdir)/niceload.pod --title "GNU niceload" \
	|| echo "Warning: pod2pdf not found. Using old niceload.pdf"

sem: parallel
	ln -fs parallel sem

DISTCLEANFILES = parallel.html sem.html sql.html niceload.html parallel_tutorial.html
EXTRA_DIST = parallel sem sql niceload \
	parallel.1 sem.1 sql.1 niceload.1 parallel_tutorial.1 \
	parallel.html sem.html sql.html niceload.html parallel_tutorial.html \
	sem.pod parallel.pod niceload.pod parallel_tutorial.pod \
	parallel.texi sem.texi sql.texi niceload.texi parallel_tutorial.texi \
	parallel.pdf sem.pdf sql.pdf niceload.pdf parallel_tutorial.pdf
