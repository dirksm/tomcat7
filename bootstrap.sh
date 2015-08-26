#!/usr/bin/env bash

# Use single quotes instead of double quotes to make it work with special-character passwords
PASSWORD='12345678'
DATABASE='ihb'
#PROJECTFOLDER='myproject'

# create project folder
#sudo mkdir "/var/www/html/${PROJECTFOLDER}"

# Add Oracle8 ppa to apt repository
sudo apt-add-repository ppa:webupd8team/java

# update / upgrade
sudo apt-get update
#sudo apt-get -y upgrade

# install apache 2.5 and php 5.5
sudo apt-get install -y apache2
sudo apt-get install -y php5

# install mysql and give password to installer
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $PASSWORD"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $PASSWORD"
sudo apt-get -y install mysql-server
sudo apt-get install php5-mysql

# install phpmyadmin and give password(s) to installer
# for simplicity I'm using the same password for mysql and phpmyadmin
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password $PASSWORD"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password $PASSWORD"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password $PASSWORD"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2"
sudo apt-get -y install phpmyadmin

# Setup database
echo `mysql -uroot -p$PASSWORD -e "CREATE DATABASE $DATABASE;"`

# Make MySQL external accessible
echo `mysql -uroot -p$PASSWORD -e "GRANT ALL PRIVILEGES ON *.* TO 'ihb'@'%' IDENTIFIED BY 'ihb';"`
echo `mysql -uroot -p$PASSWORD -e "GRANT ALL PRIVILEGES ON *.* TO 'ihb'@'localhost' IDENTIFIED BY 'ihb';"`
echo `mysql -uroot -p$PASSWORD -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$PASSWORD';"`
echo `mysql -uroot -p$PASSWORD -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' IDENTIFIED BY '$PASSWORD';"`
sed -i 's/^bind-address/#bind-address/' /etc/mysql/my.cnf
sed -i 's/^skip-external-locking/#skip-external-locking/' /etc/mysql/my.cnf
sudo service mysql restart

# Import bootstrap SQL
echo `mysql -uroot -p$PASSWORD $DATABASE < /vagrant/sql/create.sql`

# setup hosts file
#VHOST=$(cat <<EOF
#<VirtualHost *:80>
#    DocumentRoot "/var/www/html/${PROJECTFOLDER}"
#    <Directory "/var/www/html/${PROJECTFOLDER}">
#        AllowOverride All
#        Require all granted
#    </Directory>
#</VirtualHost>
#EOF
#)
#echo "${VHOST}" > /etc/apache2/sites-available/000-default.conf

# enable mod_rewrite
sudo a2enmod rewrite

# restart apache
service apache2 restart

# install git
sudo apt-get -y install git

# install Composer
#curl -s https://getcomposer.org/installer | php
#mv composer.phar /usr/local/bin/composer

# activate mcrypt
cd /etc/php5/mods-available
sudo php5enmod mcrypt

# restart apache
service apache2 restart

# Install Oracle JDK
sudo apt-get -y install oracle-java8-installer
export JAVA_HOME=/usr/lib/jvm/oracle_jdk8

#install tomcat7
sudo apt-get -y install tomcat7
#change location of webapps folder for local development
sudo sed -i 's/appBase=\"webapps\"/appBase=\"\/vagrant\/webapps\"/' /var/lib/tomcat7/conf/server.xml
sudo service tomcat7 start
