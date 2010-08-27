Summary:	Shell tool for executing jobs in parallel
Name: 		parallel
Version: 	20100722
Release: 	1
License: 	GPL
Group: 		Productivity/File utilities
URL: 		ftp://ftp.gnu.org/gnu/parallel
Source0: 	%{name}-%{version}.tar.bz2
BuildArch:	noarch
BuildRoot: 	%{_tmppath}/%{name}-%{version}-buildroot

%description
GNU Parallel is a shell tool for executing jobs in parallel using one
or more machines. A job is typically a single command or a small
script that has to be run for each of the lines in the input. The
typical input is a list of files, a list of hosts, a list of users, or
a list of tables.

If you use xargs today you will find GNU Parallel very easy to use. If
you write loops in shell, you will find GNU Parallel may be able to
replace most of the loops and make them run faster by running jobs in
parallel. If you use ppss or pexec you will find GNU Parallel will
often make the command easier to read.

GNU Parallel also makes sure output from the commands is the same
output as you would get had you run the commands sequentially. This
makes it possible to use output from GNU Parallel as input for other
programs.

%prep
if [ "${RPM_BUILD_ROOT}x" == "x" ]; then
        echo "RPM_BUILD_ROOT empty, bad idea!"
        exit 1
fi
if [ "${RPM_BUILD_ROOT}" == "/" ]; then
        echo "RPM_BUILD_ROOT is set to "/", bad idea!"
        exit 1
fi
%setup -q

%build
./configure
make

%install
rm -rf $RPM_BUILD_ROOT
make install prefix=$RPM_BUILD_ROOT%{_prefix} exec_prefix=$RPM_BUILD_ROOT%{_prefix} \
    datarootdir=$RPM_BUILD_ROOT%{_prefix} docdir=$RPM_BUILD_ROOT%{_docdir} \
    mandir=$RPM_BUILD_ROOT%{_mandir}

rm $RPM_BUILD_ROOT%{_docdir}/parallel.html

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root,-)
/usr/bin/*
/usr/share/man/man1/*
%doc README NEWS src/parallel.html


%changelog
* Sat Aug 08 2010 Markus Ammer
- Initial package setup.
