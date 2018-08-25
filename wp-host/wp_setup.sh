#/bin/bash
set -x

# Check root pertmissions
[ $(id -u) != 0 ] && echo "Im not root" && exit 1

MYSQL_ROOT_USER=debian-sys-maint
MYSQL_ROOT_PASS=fxMWpBR0UaZzX5qm
WP_USER=wordpressuser
WP_USER_PASS=password
DB_HOST=localhost
WP_DB=wordpress


apt-get -y update
apt-get -y install php5-gd libssh2-php


mysql -u"$MYSQL_ROOT_USER" -p"$MYSQL_ROOT_PASS" -e "CREATE DATABASE ${WP_DB};"
mysql -u"$MYSQL_ROOT_USER" -p"$MYSQL_ROOT_PASS" -e "CREATE USER ${WP_USER}@${DB_HOST} IDENTIFIED BY \"${WP_USER_PASS}\";"
mysql -u"$MYSQL_ROOT_USER" -p"$MYSQL_ROOT_PASS" -e "GRANT ALL PRIVILEGES ON ${WP_DB}.* TO ${WP_USER}@${DB_HOST};"
mysql -u"$MYSQL_ROOT_USER" -p"$MYSQL_ROOT_PASS" -e "FLUSH PRIVILEGES;"

cd ~
wget http://wordpress.org/latest.tar.gz
tar xzvf latest.tar.gz
cd wordpress || exit 15

wget -O- https://api.wordpress.org/secret-key/1.1/salt/ 2>/dev/null >salt.tmp
awk '/@-\*\// {print $0; while(getline line<"salt.tmp"){print line};next}1' wp-config-sample.php | \
sed '/\/\*\*#@+/,/\/\*\*#@-\*\//d' >wp-config.php
rm -f salt.tmp

sed -i -e "s/^define('DB_NAME', .*$/define('DB_NAME', \'${WP_DB}\');/" wp-config.php
sed -i -e "s/^define('DB_USER', .*$/define('DB_USER', \'${WP_USER}\');/" wp-config.php
sed -i -e "s/^define('DB_PASSWORD', .*$/define('DB_PASSWORD', \'${WP_USER_PASS}\');/" wp-config.php
sed -i -e "s/^define('DB_HOST', .*$/define('DB_HOST', \'${DB_HOST}\');/" wp-config.php

rsync -Pav --delete-before ~/wordpress/ /var/www/html/

cd /var/www/html || exit 25
chown -R vagrant:www-data *

mkdir /var/www/html/wp-content/uploads
chown -R :www-data /var/www/html/wp-content/uploads
sed -i 's~^  DocumentRoot .*$~  DocumentRoot /var/www/html~' /etc/apache2/sites-enabled/000-default.conf 
service apache2 restart

