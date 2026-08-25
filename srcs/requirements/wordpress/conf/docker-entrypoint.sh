#!/bin/sh

set -ex

get_value_of_credentials_key()
{
	result=$(grep $1 $CREDENTIALS_SCRT | tr '=' '\n' | tail -n 1)

	echo $result
}

ROOTDIR="/var/www/html"
CONF_FILE="$ROOTDIR/wp-config.php"
ENTRY_FILE="$ROOTDIR/index.php"
DB_HOST="mariadb"
CREDENTIALS_SCRT="/run/secrets/credentials"
MDB_PASSWORD_SCRT="/run/secrets/db_password"
MDB_USER=$(get_value_of_credentials_key "db_user")
MDB_PASSWORD=$(cat $MDB_PASSWORD_SCRT)
ADMIN_USER=$(get_value_of_credentials_key "wp_admin_user")
ADMIN_PASSWORD=$(get_value_of_credentials_key "wp_admin_password")
USER=$(get_value_of_credentials_key "wp_user")
USER_PASSWORD=$(get_value_of_credentials_key "wp_password")
ADMIN_EMAIL="yiken@student.1337.ma"
USER_EMAIL="temp@hotmail.fr"
HTML_PATH="/tmp/inception.html"
POST_ID=1

if [ ! -f $ENTRY_FILE ]; then
	awk '/^memory_limit/ {$0 = "memory_limit = 512M"; found = 1} {print} END {if (!found) print "memory_limit = 512M"}'	\
        /etc/php83/php.ini > /etc/php83/php.ini.tmp
	mv /etc/php83/php.ini.tmp /etc/php83/php.ini
	wp core download --path=$ROOTDIR
fi

if [ ! -f $CONF_FILE ]; then
	until nc -z mariadb 3306; do
		sleep 1
	done

	wp config create --path=$ROOTDIR --dbname=$MDB_DATABASE --dbuser=$MDB_USER						\
	--dbpass=$MDB_PASSWORD --dbhost=$DB_HOST

	wp core install --path=$ROOTDIR --url=$DOMAIN_NAME --title="$TITLE"								\
	--admin_user=$ADMIN_USER --admin_password=$ADMIN_PASSWORD --admin_email=$ADMIN_EMAIL

	wp user create --path=$ROOTDIR $USER $USER_EMAIL --role=$USER_ROLE --user_pass=$USER_PASSWORD
	wp option update --path=$ROOTDIR permalink_structure '/%postname%/'

	wp post update --path=$ROOTDIR $POST_ID --post_content="$(cat $HTML_PATH)" --post_title="Inception"			\
	--post_name="inception"
fi

exec $@
