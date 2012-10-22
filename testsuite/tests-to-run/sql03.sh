#!/bin/bash

MYSQL_ADMIN_DBURL=mysql://tange:tange@

# Setup
sql $MYSQL_ADMIN_DBURL "drop user 'sqlunittest'@'localhost'"
sql $MYSQL_ADMIN_DBURL DROP DATABASE sqlunittest;
sql $MYSQL_ADMIN_DBURL CREATE DATABASE sqlunittest;
sql $MYSQL_ADMIN_DBURL "CREATE USER 'sqlunittest'@'localhost' IDENTIFIED BY 'CB5A1FFFA5A';"
sql $MYSQL_ADMIN_DBURL "GRANT ALL PRIVILEGES ON sqlunittest.* TO 'sqlunittest'@'localhost';"

MYSQL_TEST_DBURL=mysql://sqlunittest:CB5A1FFFA5A@

echo '### Test reading sql from url command line'
echo | sql "$MYSQL_TEST_DBURL/?SELECT 'Yes it works' as 'Test reading SQL from command line';"

echo '### Test reading sql from url command line %-quoting'
echo | sql "$MYSQL_TEST_DBURL/?SELECT 'Yes it%20works' as 'Test%20%-quoting%20SQL from command line';"

echo "### Test .sql/aliases with url on commandline"
echo :sqlunittest mysql://sqlunittest:CB5A1FFFA5A@localhost:3306/sqlunittest >> ~/.sql/aliases
perl -i -ne '$seen{$_}++ || print' ~/.sql/aliases
echo | sql ":sqlunittest?SELECT 'Yes it%20works' as 'Test if .sql/aliases with %-quoting works';"

echo "### Test cyclic alias .sql/aliases"
echo :cyclic :cyclic2 >> ~/.sql/aliases
echo :cyclic2 :cyclic3 >> ~/.sql/aliases
echo :cyclic3 :cyclic >> ~/.sql/aliases
perl -i -ne '$seen{$_}++ || print' ~/.sql/aliases
stdout sql ":cyclic3?SELECT 'NO IT DID NOT' as 'Test if :cyclic is found works';"

echo "### Test alias with statement .sql/aliases"
echo ":testselect sqlite:////tmp/file.sqlite?SELECT 'It works' AS 'Test statement in alias';" >> ~/.sql/aliases
perl -i -ne '$seen{$_}++ || print' ~/.sql/aliases
echo | stdout sql :testselect
echo ":testselectmysql mysql://sqlunittest:CB5A1FFFA5A@localhost:3306/sqlunittest?SELECT 'It works' AS 'Test statement in alias';" >> ~/.sql/aliases
perl -i -ne '$seen{$_}++ || print' ~/.sql/aliases
echo | stdout sql :testselect
echo | stdout sql :testselectmysql

echo "### Test alias followed by SQL as arg"
echo ignored | stdout sql :testselect "select 'Arg on cmdline';"

echo "### Test alias with query followed by SQL as arg"
echo ignored | stdout sql :testselect" select 'Query added to alias';" "select 'Arg on cmdline';"

echo "### Test alias with statement .sql/aliases"
echo "select 'Query from stdin';" | sql :testselect" select 'Query added to alias';"
echo "select 'Query from stdin';" | sql :testselectmysql" select 'Query added to alias';"

echo "### Test empty dburl"
stdout sql ''

echo "### Test dburl :"
stdout sql ':'

echo "### Test oracle with multiple arguments on the command line"
echo ":oraunittest oracle://hr:hr@/xe" >> ~/.sql/aliases
perl -i -ne '$seen{$_}++ || print' ~/.sql/aliases
sql :oraunittest "WHENEVER SQLERROR EXIT FAILURE" "SELECT 'arg2' FROM DUAL;" "SELECT 'arg3' FROM DUAL;"

echo "### Test oracle with \n arguments on the command line"
sql :oraunittest 'select 1 from dual;\nselect 2 from dual;\x0aselect 3 from dual;'
