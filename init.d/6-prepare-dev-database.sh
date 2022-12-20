#!/usr/bin/env bash

# Start the MySQL daemon in the background.
/usr/bin/mysqld --user="${MYSQL_USER}" &
MYSQL_PID=$!

until mysqladmin ping >/dev/null 2>&1; do
  echo -n "."; sleep 0.2
done

# TODO why mysqld --bootstrap doesn't work here?

## MariaDB 10.4.3 uses socket authentication by default.
mysql -uroot << EOF
CREATE USER IF NOT EXISTS 'root'@'%' IDENTIFIED WITH mysql_native_password;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;
DROP DATABASE IF EXISTS test;
EOF

# Tell the MySQL daemon to shutdown.
mysqladmin shutdown

# Wait for the MySQL daemon to exit.
wait $MYSQL_PID
