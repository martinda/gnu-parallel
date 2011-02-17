all:	clean unpack build

unpack:
	ls ../../parallel-*.tar.bz2| tail -n1 | parallel tar xvf 
	cd parallel-[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]; cp -a ../debian-template debian

build:
	cd parallel-[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]; debchange -i
	cd parallel-[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]; dpkg-buildpackage -us -uc

clean:
	rm -f parallel_*
	rm -rf parallel-[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]

distclean:
	rm -f parallel_*
	rm -rf parallel-[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]

