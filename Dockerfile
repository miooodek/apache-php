FROM ubuntu:trusty
MAINTAINER Fernando Mayo <fernando@tutum.co>

# Install base packages
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -yq install \
        curl \
        apache2 \
        libapache2-mod-php5 \
        php5-mysql \
        php5-mcrypt \
        php5-gd \
        php5-curl \
        php-pear \
        php-apc && \
    rm -rf /var/lib/apt/lists/* && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN /usr/sbin/php5enmod mcrypt
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf && \
    sed -i "s/variables_order.*/variables_order = \"EGPCS\"/g" /etc/php5/apache2/php.ini


# Dowlnoad image and configure /kursomat folder 
WORKDIR /
RUN curl -0L https://www.dropbox.com/s/ra10yu144ruw2o5/kursomat.tar.gz | tar zxv && \
    rm -fr /var/www/html && \
    ln -s /kursomat/wordpress /var/www/html && \
    && ln -s /kursomat/backend /var/www/
    

# Add image configuration and scripts
ADD run.sh /run.sh
RUN chmod 755 /*.sh

EXPOSE 80
WORKDIR /kursomat
VOLUME ["/kursomat"]
CMD ["/run.sh"]
