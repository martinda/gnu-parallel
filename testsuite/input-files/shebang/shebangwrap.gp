#!/usr/bin/parallel --shebang-wrap -k A={} /usr/bin/gnuplot

name=system("echo $A")
print name
