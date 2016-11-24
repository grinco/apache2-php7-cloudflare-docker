FROM tutum/apache-php

# Install Packages
RUN apt-get update
RUN apt-get -y dist-upgrade
RUN apt-get -y install wget software-properties-common libapache2-mod-rpaf
RUN apt-get install -y language-pack-en-base 
RUN LC_ALL=en_US.UTF-8 add-apt-repository -y ppa:ondrej/php
RUN apt-get update
RUN apt-get -y install libapache2-mod-php7.0 php7.0-memcache php7.0-memcached php7.0-readline php7.0-recode php7.0-xsl php7.0-mcrypt php7.0-curl php7.0-mysql php7.0-bcmath php7.0-zip

# Install and configure apache cloudflare module
RUN wget https://www.cloudflare.com/static/misc/mod_cloudflare/ubuntu/mod_cloudflare-trusty-amd64.latest.deb -O /tmp/mod_cloudflare-trusty-amd64.latest.deb
RUN dpkg -i /tmp/mod_cloudflare-trusty-amd64.latest.deb

# Configure cloudflare
RUN sed -i -e 's/CloudFlareRemoteIPTrustedProxy/CloudFlareRemoteIPTrustedProxy 172.16.0.0\/12 192.168.0.0\/16 10.0.0.0\/8/' /etc/apache2/mods-enabled/cloudflare.conf

# Disable php5
RUN a2dismod php5

# Enable php7
RUN a2enmod php7.0

# Bundle www directory
COPY /www/ /app/
RUN chown -R www-data:www-data /app/
WORKDIR /app

EXPOSE 80

CMD ["/run.sh"]

