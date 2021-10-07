#!/bin/bash

echo "Installing HTTPD"
yum install -y httpd

echo "Starting HTTPD"
systemctl start httpd.service

echo "Adding Firewall Rules"
firewall-cmd ––add-port 80/tcp ––permanent 
firewall-cmd ––reload

echo "Installing PHP Apache"
yum install -y php php-mysql

echo "Starting PHP Apache"
systemctl restart httpd.service

echo "Findout"
yum info php-fpm

echo "Installing PHP-FPM"
yum install -y php-fpm

cd /var/www/html/
echo'<?php phpinfo();?'> index.php

