# wp-host.sh
##  The WordPress site with self-signed certificate
=============================================================================================


### Project prerequizites:
- VirtualBox (ver. >5.0)
- Vagrant (ver. >2.0)

#### Used resources:
- vagrant box: [xplore/ubuntu-14.04](https://app.vagrantup.com/xplore/boxes/ubuntu-14.04)
  
#### Usage:
- _Start VM:_    
   vagrant up  
- _Visit WP site:_  
   [http://localhost:8080](http://localhost:8080)
----------------------------------------------------------------------------------------------

#### Used manuals:
- [WP installation](https://www.digitalocean.com/community/tutorials/how-to-install-wordpress-on-ubuntu-14-04)  
- [Configure Apache self-signed SSL cert:](https://www.sslshopper.com/article-how-to-create-and-install-an-apache-self-signed-certificate.html)  
- [Automate openssl](https://www.shellhacks.com/create-csr-openssl-without-prompt-non-interactive/)  

##### Generate SSL self-signed certificate 
###### Generate a passphrase
openssl rand -base64 48 > passphrase.txt

###### Generate a Private Key
openssl genrsa -aes128 -passout file:passphrase.txt -out server.key 2777

###### Generate a CSR (Certificate Signing Request)
openssl req -new -passin file:passphrase.txt -key server.key -out server.csr \
-subj "/C=FR/O=foo/OU=Domain Control Validated/CN=example.com"

###### Remove Passphrase from Key
cp server.key server.key.org
openssl rsa -in server.key.org -passin file:passphrase.txt -out server.key

###### Generating a Self-Signed Certificate for 100 years
openssl x509 -req -days 36500 -in server.csr -signkey server.key -out server.crt
  
==============================================================================================

#### Notes and fixed bugs:
1. Do not forget update document root:  
   _# vim /etc/apache2/sites-enabled/000-default.conf_  
```
<VirtualHost *:80>
  ServerAdmin webmaster@localhost

  DocumentRoot /var/www/html  
  DirectoryIndex index.php index.html  
```  
2. Enable SSL apache module:  
   _# sudo a2enmod ssl_
3. Update RW permissions on .../uploads folder:  
   _# chmod -R g+w /var/www/html/wp-content/uploads_


#### Setup history:  
```
    1  ll
    2  mysql -u root -p
    3  mysql -u root -XXXXXX
    4  mysql -u root 
    5  mysql -u root -"XXXXXX"
    6  mysql -u root -'XXXXXXX'
    7  ll
    8  mysql -u root -p
    9  ll
   10  cd /etc
   11  ll
   12  cd mysql/
   13  ll
   14  cat debian
   15  cat debian.cnf 
   16  cd ..
   17  pwd
   18  ll
   19  cd /root
   20  ll
   21  mysql -u root -p
   22  pwd
   23  mysql -u root -p
   24  cd /etc
   25  cd mysql/
   26  ll
   27  cat debian.cnf 
   28  cd /
   29  cd root
   30  cd /etc/mysql/
   31  ll
   32  cat debian.cnf 
   33  cd /root
   34  pwd
   35  mysql -u debian-sys-maint -p
   36  cd ~
   37  pwd
   38  wget http://wordpress.org/latest.tar.gz
   39  tar xzvf latest.tar.gz
   40  apt-get update
   41  apt-get install php5-gd libssh2-php
   42  cd ~/wordpress
   43  pwd
   44  cp wp-config-sample.php wp-config.php
   45  curl -s https://api.wordpress.org/secret-key/1.1/salt/
   46  apt-get install curl
   47  curl -s https://api.wordpress.org/secret-key/1.1/salt/
   48  vim wp-config.php
   49  apt-get install vim
   50  vim wp-config.php
   51  mysql -u -p''
   52  mysql -u -p'XXXXXXX'
   53  mysql -u -p'XXXXXXX'
   54  pwd
   55  rsync -avP ~/wordpress/ /var/www/html/
   56  cd /var/www/html
   57  chown -R demo:www-data *
   58  chown -R demo:www-data 
   59  chown --help
   60  chown -R demo:www-data *
   61  mkdir /var/www/html/wp-content/uploads
   62  chown -R :www-data /var/www/html/wp-content/uploads
   63  ps -axfu | grep apache
   64  users
   65  w
   66  cat /etc/passwd
   67  cd /var/www/html; chown -R vagrant:www-data *
   68  chown -R :www-data /var/www/html/wp-content/uploads
   69  mkdir /var/www/html/wp-content/uploads
   70  chown -R :www-data /var/www/html/wp-content/uploads
   71  rsync -avP ~/wordpress/ /var/www/html/ 
   72  chown -R :www-data /var/www/html/wp-content/uploads
   73  rsync -avP ~/wordpress/ /var/www/html/
   74  ll
   75  wim wp-config.php
   76  apt-get install vim
   77  wim wp-config.php
   78  ll
   79  vim wp-config.php
   80  reboot
   81  cd /etc
   82  cd apache2/
   83  cd sites-enabled/
   84  ll
   85  vim 000-default.conf 
   86  service apache2 restart 
   87  history
   88  vim 000-default.conf 
   89  service apache2 restart 
   90  vim 000-default.conf 
   91  service apache2 restart 
   92  git remote branch
   93  ll
   94  reload
   95  v reload
   96  reload --system 
   97  openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout mysitename.key -out mysitename.crt
   98  cd /etc/
   99  cd httpd
  100  ll
  101  cd ..
  102  cd /etc/httpd/
  103  ll
  104  cd /etc/apache2/
  105  ll
  106  vim apache2.conf 
  107  ll
  108  pwd
  109  ll
  110  hostname
  111  ls /root
  112  mc
  113  apt-get install mc
  114  mc
  115  ll
  116  cd /etc
  117  ll
  118  cd apache2/
  119  ll
  120  vim apache2.conf 
  121  cd sites-enabled/
  122  ll
  123  vim 000-default.conf 
  124  ll /rrot
  125  ll /root
  126  mv /root/mysitename.* /etc/ssl/private/
  127  sudo a2enmod ssl
  128  reboot
  129  history >/vagrant/setup-history.txt
```
