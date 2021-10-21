#!/bin/bash

echo "########## INSTALLING HTTPD NOW ##########"
yum install -y httpd

echo "########## STARTING HTTPD NOW ##########"
systemctl start httpd.service

echo "########## ADDING FIREWALL RULES NOW ##########"
firewall-cmd --permanent --add-port=80/tcp
firewall-cmd --permanent --add-port=443/tcp
firewall-cmd --reload

echo "########## INSTALLING PHP APACHE NOW ##########"
yum install -y php php-mysql

echo "########## STARTING PHP APACHE NOW ##########"
systemctl restart httpd.service

echo "##########  CHECKING YUM INFO NOW ##########"
yum info php-fpm

echo "########## INSTALLING PHP-FPM  NOW ##########"
yum install -y php-fpm

cd /var/www/html/
echo '<?php phpinfo(); ?>' > index.php

echo "########## INSTALLING MARIADB NOW ##########"
yum install -y mariadb-server mariadb

echo "########## STARTING MARIADB NOW ##########"
systemctl start mariadb

echo "########## TESTING SIMPLE SECURITY SCRIPT NOW ##########"
mysql_secure_installation <<EOF

y
root
root
y
y
y
y
EOF

echo "########## ENABLING MARIADB NOW ##########"
systemctl enable mariadb

echo "########## MARIADB ENABLE ##########"
#variables
passw=root
dbname=wordpress

echo "########## VERIFYING INSTALLATION NOW ##########"
mysqladmin -u root -p$passw version

echo "CREATE DATABASE wordpress; CREATE USER wordpressuser@localhost IDENTIFIED BY 'root'; GRANT ALL PRIVILEGES ON wordpress.* TO wordpressuser@localhost IDENTIFIED BY 'root'; FLUSH PRIVILEGES; show databases;" | mysql -u root -p$passw

echo "########## INSTALLING WORDPRESS NOW ##########"
yum install -y php-gd

echo "########## RESTARTING APACHE NOW ##########"
service httpd restart

echo "########## INSTALLING WGET NOW ##########"
yum install -y wget

echo "########## INSTALLING TAR NOW ##########"
yum install -y tar

cd /opt/
wget http://wordpress.org/latest.tar.gz
tar xzvf latest.tar.gz

echo "########## INSTALLING RSYNC NOW ##########"
yum install -y rsync
rsync -avP wordpress/ /var/www/html/
cd /var/www/html/
mkdir /var/www/html/wp-content/uploads
chown -R apache:apache /var/www/html/*
cp wp-config-sample.php wp-config.php
sed -i 's/database_name_here/wordpress/g' wp-config.php
sed -i 's/username_here/wordpressuser/g' wp-config.php
sed -i 's/password_here/root/g' wp-config.php

echo "########## updating php ##########"
yum install -y http://rpms.remirepo.net/enterprise/remi-release-7.rpm
yum install -y yum-utils
yum-config-manager --enable remi-php56 
yum install -y php php-mcrypt php-cli php-gd php-curl php-mysql php-ldap php-zip php-fileinfo
systemctl restart httpd.service
