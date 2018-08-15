#/bin/bash
set +x

# Check root pertmissions
[ $(id -u) != 0 ] && echo "You should be root! Exitting ..." && exit 1

MYSQL_ROOT_USER=debian-sys-maint
MYSQL_ROOT_PASS=fxMWpBR0UaZzX5qm
WP_USER=wordpressuser
WP_USER_PASS=password
DB_HOST=localhost
WP_DB=wordpress

## Update apps and setup dependencies
apt-get -y -qq update
apt-get -y install php5-gd libssh2-php mc vim

## Configure MySQL user for WP
mysql -u"$MYSQL_ROOT_USER" -p"$MYSQL_ROOT_PASS" -e "\
                                                     CREATE USER ${WP_USER}@${DB_HOST} IDENTIFIED BY \"${WP_USER_PASS}\"; \
                                                     GRANT ALL PRIVILEGES ON ${WP_DB}.* TO ${WP_USER}@${DB_HOST};  \
                                                     CREATE DATABASE $WP_DB ;  \
                                                     FLUSH PRIVILEGES;"
## Setup WP
wget -q http://wordpress.org/latest.tar.gz
tar xzf latest.tar.gz && echo "==== OK. Latest WP successfully downloaded and extracted."
cd wordpress || exit 15

## Configure WP:
# Generate salt hashes for wp
wget -O- https://api.wordpress.org/secret-key/1.1/salt/ 2>/dev/null >salt.tmp
awk '/@-\*\// {print $0; while(getline line<"salt.tmp"){print line};next}1' wp-config-sample.php | \
sed '/\/\*\*#@+/,/\/\*\*#@-\*\//d' >wp-config.php
rm -f salt.tmp
# Update wp-config.php
sed -i -e "s/^define('DB_NAME', .*$/define('DB_NAME', \'${WP_DB}\');/" wp-config.php
sed -i -e "s/^define('DB_USER', .*$/define('DB_USER', \'${WP_USER}\');/" wp-config.php
sed -i -e "s/^define('DB_PASSWORD', .*$/define('DB_PASSWORD', \'${WP_USER_PASS}\');/" wp-config.php
sed -i -e "s/^define('DB_HOST', .*$/define('DB_HOST', \'${DB_HOST}\');/" wp-config.php
echo;echo =========================================== WP-CONFIG ===============================================================
cat wp-config.php
echo ==========================================================================================================================
echo

## Copying site content configure and set proper permissions
rsync -a --delete-before . /var/www/html/ 
cd .. 
[ -d wordpress ] && rm -fr wordpress latest.tar.gz
cd /var/www/html || exit 25
chown -R vagrant:www-data *
mkdir /var/www/html/wp-content/uploads
chmod -R g+w /var/www/html/wp-content/uploads
chown -R :www-data /var/www/html/wp-content/uploads
sed -i 's~^  DocumentRoot .*$~  DocumentRoot /var/www/html~' /etc/apache2/sites-enabled/000-default.conf 

## Restart and check
service apache2 restart
echo;echo ================== Running services: ================================================================================
ss -tlpn
echo ================= COMPLETED ========================================================================= exit code: $? ======

