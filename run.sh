#!/usr/bin/env bash

set -ex;

mysql.server start

DB_USER=${1-root}
DB_PASS=$2
DB_NAME=${3-wpdev}
PORT=8080
WP_PATH=$(pwd)/trunk/src
WP_TITLE='Welcome to the WordPress'
WP_DESC='Hello World!'

if [ -e "$WP_PATH/wp-config.php" ]; then
    open http://127.0.0.1:$PORT
    wp server --host=0.0.0.0 --port=$PORT --docroot=$WP_PATH
    exit 0
fi

echo "path: trunk/src" > $(pwd)/wp-cli.yml

if [ $DB_PASS ]; then
    echo "DROP DATABASE IF EXISTS $DB_NAME;" | mysql -u$DB_USER -p$DB_PASS
    echo "CREATE DATABASE $DB_NAME DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;" | mysql -u$DB_USER -p$DB_PASS
else
    echo "DROP DATABASE IF EXISTS $DB_NAME;" | mysql -u$DB_USER
    echo "CREATE DATABASE $DB_NAME DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;" | mysql -u$DB_USER
fi

svn co http://develop.svn.wordpress.org/trunk/ trunk

if [ $DB_PASS ]; then
wp core config \
--dbhost=localhost \
--dbname="$DB_NAME" \
--dbuser="$DB_USER" \
--dbpass="$DB_PASS" \
--dbprefix=wp_ \
--locale=en_US \
--extra-php <<PHP
define( 'JETPACK_DEV_DEBUG', true );
define( 'WP_DEBUG', true );
PHP
else
wp core config \
--dbhost=localhost \
--dbname=$DB_NAME \
--dbuser=$DB_USER \
--dbprefix=wp_ \
--locale=en_US \
--extra-php <<PHP
define( 'JETPACK_DEV_DEBUG', true );
define( 'WP_DEBUG', true );
PHP
fi

wp core install \
--url=http://127.0.0.1:$PORT \
--title="WordPress" \
--admin_user="admin" \
--admin_password="admin" \
--admin_email="admin@example.com"

wp rewrite structure "/archives/%post_id%"

wp option update blogname "$WP_TITLE"
wp option update blogdescription "$WP_DESC"

open http://127.0.0.1:$PORT
wp server --host=0.0.0.0 --port=$PORT --docroot=$WP_PATH
