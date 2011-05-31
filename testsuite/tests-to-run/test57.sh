#!/bin/bash

echo '### Test {//}'
parallel -k echo {//} {} ::: a a/b a/b/c
parallel -k echo {//} {} ::: /a /a/b /a/b/c
parallel -k echo {//} {} ::: ./a ./a/b ./a/b/c
parallel -k echo {//} {} ::: a.jpg a/b.jpg a/b/c.jpg
parallel -k echo {//} {} ::: /a.jpg /a/b.jpg /a/b/c.jpg
parallel -k echo {//} {} ::: ./a.jpg ./a/b.jpg ./a/b/c.jpg

echo '### Test {1//}'
parallel -k echo {1//} {} ::: a a/b a/b/c
parallel -k echo {1//} {} ::: /a /a/b /a/b/c
parallel -k echo {1//} {} ::: ./a ./a/b ./a/b/c
parallel -k echo {1//} {} ::: a.jpg a/b.jpg a/b/c.jpg
parallel -k echo {1//} {} ::: /a.jpg /a/b.jpg /a/b/c.jpg
parallel -k echo {1//} {} ::: ./a.jpg ./a/b.jpg ./a/b/c.jpg

echo '### Test --dnr'
parallel --dnr II -k echo II {} ::: a a/b a/b/c

echo '### Test --dirnamereplace'
parallel --dirnamereplace II -k echo II {} ::: a a/b a/b/c
