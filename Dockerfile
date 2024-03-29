FROM ubuntu:xenial
RUN yes | apt update
RUN apt install -y  software-properties-common
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 4F4EA0AAE5267A6C
RUN LC_ALL=C.UTF-8 add-apt-repository -y ppa:ondrej/php
RUN yes | apt update
RUN apt install -y curl nano iputils-ping curl nginx
RUN export DEBIAN_FRONTEND=noninteractive
RUN apt install -y tzdata
RUN ln -fs /usr/share/zoneinfo/Europe/Istanbul /etc/localtime
RUN dpkg-reconfigure --frontend noninteractive tzdata
RUN apt-get -y update && apt-get install -y php7.1 php7.1-fpm php7.1-cli php-mbstring php7.1-mbstring php-intl php7.1-intl php7.1-gd php7.1-xml zip unzip php7.1-zip php7.1-curl php7.1-mysql php-mysql php-pear php7.1-dev php-xml php7.1-xml
RUN update-alternatives --set php /usr/bin/php7.1
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt install -y nodejs
RUN npm install -g forever babel-loader node-babel
RUN mkdir -p /web
RUN yes | pecl install xdebug \
    && echo "[XDebug]" > /etc/php/7.1/fpm/conf.d/xdebug.ini \
    && echo "zend_extension=$(find /usr/lib/php/ -name xdebug.so)" > /etc/php/7.1/fpm/conf.d/xdebug.ini \
    && echo "xdebug.remote_enable=on" >> /etc/php/7.1/fpm/conf.d/xdebug.ini \
    && echo "xdebug.remote_autostart=off" >> /etc/php/7.1/fpm/conf.d/xdebug.ini
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php composer-setup.php
RUN php -r "unlink('composer-setup.php');"
RUN cp ./composer.phar /usr/bin/composer
RUN ./composer.phar global require hirak/prestissimo
CMD /etc/init.d/php7.1-fpm restart
