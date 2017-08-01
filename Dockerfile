############################################################
# Dockerfile to install wordpress
# Based on Ubuntu:14.04
############################################################

# Set the base image to Ubuntu
FROM ubuntu:14.04

# File Author / Maintainer
MAINTAINER wordpress.opstree.com

# Update the repository sources list
RUN apt-get update

################## BEGIN INSTALLATION #####################
# Install mysql for database
#RUN apt-get install -y mysql-server

# Start the service or mysql
#RUN /etc/init.d/mysql start  && \
#mysql -uroot &&  \
# "CREATE DATABASE wordpress" && \
#"#CREATE USER wordpressuser@localhost IDENTIFIED BY 'password'" && \
 #"GRANT ALL PRIVILEGES ON wordpress.* TO wordpressuser@localhost" && \
 #"FLUSH PRIVILEGES" && \
# exit

#Install wordpress & php 5,php5 fpm,php5-mysql
RUN cd /opt/ 
RUN apt-get install -y wget 
RUN  wget http://wordpress.org/latest.tar.gz 
RUN tar xzvf latest.tar.gz 
RUN apt-get install -y php5-gd libssh2-php 
RUN apt-get install -y php5-fpm 
RUN apt-get install -y php5-mysql 
RUN service php5-fpm restart

#change the directory and copy
RUN cd wordpress; \
cp wp-config-sample.php wp-config.php

#Install curl and run command to generate the seceret keys
#RUN curl -s https://api.wordpress.org/secret-key/1.1/salt/ >> /opt/wordpress/wp-config.php

#Install vim editor
#RUN apt-get install vim
RUN sed -i -e 's/database_name_here/wordpress/g' wp-config.php; \
sed -i -e 's/database_name_here/wordpressuser/g' wp-config.php; \
sed -i -e 's/password_here/password/g' wp-config.php; \


#make a directory in /var/www/html
RUN cd /var; \
mkdir www; \
cd www; \
mkdir html; \ 
cp -r /opt/wordpress/* /var/www/html

#Install ngnix 
RUN apt-get install ngnix; \
cp /etc/nginx/sites-available/default /etc/nginx/sites-available/wordpress
