#!/bin/sh

get_value_of_credentials_key()
{
	result=$(grep $1 $CREDENTIALS_SCRT | tr '=' '\n' | tail -n 1)

	echo $result
}

set -ex

DATADIR="/var/lib/mysql"
MDB_ROOT_PASSWORD_SCRT="/run/secrets/db_root_password"
MDB_PASSWORD_SCRT="/run/secrets/db_password"
CREDENTIALS_SCRT="/run/secrets/credentials"
MDB_ROOT_PASSWORD=$(cat $MDB_ROOT_PASSWORD_SCRT)
MDB_USER=$(get_value_of_credentials_key "db_user")
MDB_PASSWORD=$(cat $MDB_PASSWORD_SCRT)

# Only Applied When Uninitialized
if [ ! -d "$DATADIR/mysql" ]; then

	# Bootstrapping MariaDB
	mariadb-install-db --user=mysql --datadir="$DATADIR"

	# Start The Temporary server
	mysqld --user=mysql --skip-networking --socket=/tmp/mysql.sock --datadir="$DATADIR" &
	pid="$!"

	# Enter Loop Until Server Is Ready
	until mariadb --protocol=socket -uroot -S /tmp/mysql.sock -e "SELECT 1" &> /dev/null; do
		sleep 1
	done

	# Hardenning MariaDB
	mariadb --protocol=socket -uroot -S /tmp/mysql.sock <<- EOFSQL
		alter user 'root'@'localhost' identified by '${MDB_ROOT_PASSWORD}';
		delete from mysql.user where User='';
		drop database test;
		flush privileges;
	EOFSQL

	# WordPress Database Setup
	mariadb --protocol=socket -uroot -p"${MDB_ROOT_PASSWORD}" -S /tmp/mysql.sock <<- EOFSQL
		create database ${MDB_DATABASE};
		create user '${MDB_USER}'@'%' identified by '${MDB_PASSWORD}';
		grant all privileges on ${MDB_DATABASE}.* to '${MDB_USER}'@'%';
	EOFSQL

	kill -s TERM "$pid"
	wait "$pid"
fi

exec $@
