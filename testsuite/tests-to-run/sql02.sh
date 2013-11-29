#!/bin/bash

cd /tmp
echo '### Test of sqlite'
for CMDSQL in sqlite sqlite3 ; do
    echo "Current command: $CMDSQL"
    rm -f sqltest.$CMDSQL
    # create database & table
    sql $CMDSQL:///sqltest.$CMDSQL "CREATE TABLE foo(n INT, t TEXT);"
    sql --list-tables $CMDSQL:///sqltest.$CMDSQL
    file sqltest.$CMDSQL
    sql $CMDSQL:///sqltest.$CMDSQL "INSERT INTO foo VALUES(1,'Line 1');"
    sql $CMDSQL:///sqltest.$CMDSQL "INSERT INTO foo VALUES(2,'Line 2');"
    sql $CMDSQL:///sqltest.$CMDSQL "SELECT * FROM foo;"
    sql -n $CMDSQL:///sqltest.$CMDSQL "SELECT * FROM foo;"
    sql -s '.' $CMDSQL:///sqltest.$CMDSQL "SELECT * FROM foo;"
    sql -n -s '.' $CMDSQL:///sqltest.$CMDSQL "SELECT * FROM foo;"
    sql -s '' $CMDSQL:///sqltest.$CMDSQL "SELECT * FROM foo;"
    sql -s '	' $CMDSQL:///sqltest.$CMDSQL "SELECT * FROM foo;"
    sql --html $CMDSQL:///sqltest.$CMDSQL "SELECT * FROM foo;"
    sql -n --html $CMDSQL:///sqltest.$CMDSQL "SELECT * FROM foo;"
    sql --dbsize $CMDSQL:///sqltest.$CMDSQL
    sql $CMDSQL:///sqltest.$CMDSQL "DROP TABLE foo;"
    sql --dbsize $CMDSQL:///sqltest.$CMDSQL
    rm -f sqltest.$CMDSQL
done

