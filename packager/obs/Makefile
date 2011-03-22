all:
	cd ../debian/ && make
	cp ../debian/parallel_*.dsc ../debian/parallel_*.tar.gz home\:tange/parallel/
	cp `ls ../../parallel-*.tar.bz2|tail -n1` home\:tange/parallel/
	cd home\:tange/parallel/ && osc up && osc add *.dsc *.tar.gz *.tar.bz2 || true
	cd home\:tange/parallel/ && osc up && osc *.spec || true
	cd home\:tange/parallel/ && osc ci
