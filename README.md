# wp-host
  Site with WORDPRESS with self-signed certificate



### Project prerequizites:
- VirtualBox (ver. >5.0)
- Vagrant (ver. >2.0)

#### Used resources:
- vagrant box: [xplore/ubuntu-14.04](https://app.vagrantup.com/xplore/boxes/ubuntu-14.04)
  


#### Documentation:
- [WP installation](https://www.digitalocean.com/community/tutorials/how-to-install-wordpress-on-ubuntu-14-04)
- [Setup self-signed SSL](https://devcenter.heroku.com/articles/ssl-certificate-self)
- [Automate openssl](https://www.shellhacks.com/create-csr-openssl-without-prompt-non-interactive/)

#### Usage:

- Start VM:   vagrant up  

#### Notes:
--------------------------------------------------------------------
_Do not forget update document root:_

root@vagrant:~# vim /etc/apache2/sites-enabled/000-default.conf 

<VirtualHost *:80>
  ServerAdmin webmaster@localhost

  DocumentRoot /var/www/html
  
  ...
  
