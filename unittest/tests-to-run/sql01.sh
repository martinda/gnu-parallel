#!/bin/bash

# Setup
sql mysql://root@ "drop user 'sqlunittest'@'localhost'"
sql mysql://root@ DROP DATABASE sqlunittest;
sql mysql://root@ CREATE DATABASE sqlunittest;
sql mysql://root@ "CREATE USER 'sqlunittest'@'localhost' IDENTIFIED BY 'CB5A1FFFA5A';"
sql mysql://root@ "GRANT ALL PRIVILEGES ON sqlunittest.* TO 'sqlunittest'@'localhost';"

echo '### Test of #! -Y with file as input'
cat >/tmp/shebang <<EOF
#!/usr/local/bin/sql -Y mysql:///tange

SELECT 'Yes it does' AS 'Testing if -Y works';
EOF
chmod 755 /tmp/shebang
/tmp/shebang

echo '### Test of #! --shebang with file as input'
cat >/tmp/shebang <<EOF
#!/usr/local/bin/sql --shebang mysql:///tange

SELECT 'Yes it does' AS 'Testing if --shebang works';
EOF
chmod 755 /tmp/shebang
/tmp/shebang

echo '### Test reading sql on command line'
sql mysql:///tange "SELECT 'Yes it does' as 'Test reading SQL from command line';"

echo '### Test reading sql from file'
cat >/tmp/unittest.sql <<EOF
DROP TABLE IF EXISTS unittest;
CREATE TABLE unittest (
          id INT,
          data VARCHAR(100)
        );
INSERT INTO unittest VALUES (1,'abc');
INSERT INTO unittest VALUES (3,'def');
SELECT 'Yes it does' as 'Test reading SQL from file works';
EOF
sql mysql:///tange </tmp/unittest.sql

echo '### Test dburl with username password host port'
sql mysql://sqlunittest:CB5A1FFFA5A@localhost:3306/sqlunittest </tmp/unittest.sql

echo "### Test .dburl.aliases"
echo :sqlunittest mysql://sqlunittest:CB5A1FFFA5A@localhost:3306/sqlunittest >> ~/.dburl.aliases
sql :sqlunittest "SELECT 'Yes it does' as 'Test if .dburl.aliases works';"

echo "### Test --noheaders --no-headers -n"
sql -n :sqlunittest 'select * from unittest' | parallel --colsep '\t' echo {2} {1}
sql --noheaders :sqlunittest 'select * from unittest' | parallel --colsep '\t' echo {2} {1}
sql --no-headers :sqlunittest 'select * from unittest' | parallel --colsep '\t' echo {2} {1}

echo "### Test --sep -s";
sql --no-headers -s : pg:/// 'select 1,2' | parallel --colsep ':' echo {2} {1}
sql --no-headers --sep : pg:/// 'select 1,2' | parallel --colsep ':' echo {2} {1}

echo "### Test --passthrough -p";
sql -p -H :sqlunittest 'select * from unittest'
echo
sql --passthrough -H :sqlunittest 'select * from unittest'
echo

echo "### Test --html";
sql --html mysql:///tange 'select * from unittest'
echo

echo "### Test --show-processlist|proclist|listproc";
sql --show-processlist :sqlunittest | wc
sql --proclist :sqlunittest | wc
sql --listproc :sqlunittest | wc

echo "### Test --db-size --dbsize";
sql --dbsize :sqlunittest | wc
sql --db-size :sqlunittest | wc

echo "### Test --table-size --tablesize"
sql --tablesize :sqlunittest | wc -l
sql --table-size :sqlunittest | wc -l

echo "### Test --debug"
sql --debug :sqlunittest "SELECT 'Yes it does' as 'Test if --debug works';"

echo "### Test --version -V"
sql --version | wc
sql -V | wc

echo "### Test -r"
stdout sql -r --debug pg://nongood@127.0.0.3:2227/ "SELECT 'This should fail 3 times';"

echo "### Test --retries=s"
stdout sql --retries=4 --debug pg://nongood@127.0.0.3:2227/ "SELECT 'This should fail 4 times';"

echo "### Test --help -h"
sql --help
sql -h
