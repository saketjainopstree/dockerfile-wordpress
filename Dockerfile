FROM ubuntu:14.04

RUN apt-get update
RUN apt-get install -y nginx wget \
                        supervisor \
                        curl \
                        php5-gd php5-fpm php5-mysql \
                        libssh2-php ;
RUN apt-get install -y mysql-server
RUN service mysql start ; \
        mysql -uroot -e "CREATE DATABASE wordpress; \
        GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpressuser'@'localhost' IDENTIFIED BY 'password'; \
        FLUSH PRIVILEGES; "

RUN mkdir -p /var/www/html
WORKDIR /var/www/html

RUN wget http://wordpress.org/latest.tar.gz
RUN tar xzvf latest.tar.gz

RUN curl -s https://api.wordpress.org/secret-key/1.1/salt/ >> /tmp/test.txt
RUN cp /var/www/html/wordpress/wp-config-sample.php /var/www/html/wordpress/wp-config.php
RUN sed -i '/unique/d' /var/www/html/wordpress/wp-config.php
RUN sed -i '48r /tmp/test.txt' /var/www/html/wordpress/wp-config.php

RUN sed -i -e 's/database_name_here/wordpress/g' /var/www/html/wordpress/wp-config.php
RUN sed -i -e 's/username_here/wordpressuser/g' /var/www/html/wordpress/wp-config.php
RUN sed -i -e 's/password_here/password/g' /var/www/html/wordpress/wp-config.php

RUN cp -rfv /var/www/html/wordpress/*  /var/www/html/
COPY wordpress /etc/nginx/sites-available/
RUN  ln -s /etc/nginx/sites-available/wordpress /etc/nginx/sites-enabled/wordpress
RUN  unlink /etc/nginx/sites-enabled/default &&  rm /etc/nginx/sites-available/default


COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
EXPOSE 80
EXPOSE 3306


CMD ["/usr/bin/supervisord"]
