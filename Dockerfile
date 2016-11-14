FROM ubuntu:latest
MAINTAINER Ben Menzies <benzies@gmail.com>

RUN	apt-get update \ 
	# Install dependencies
	&& apt-get install -y --no-install-recommends apt-utils tar wget apache2 libapache2-mod-php* php-mbstring php*-xml \
	# Download dokuwiki. TODO - Security check.
	&& mkdir /data \
	&& wget --no-check-certificate http://download.dokuwiki.org/src/dokuwiki/dokuwiki-stable.tgz -P /data \
	# Apache changes so Dokuwiki works straigh away.
	## Replace 'html' with 'dokuwiki', for /var/www.
	&& a2enmod rewrite \
	&& sed -i -e 's~DocumentRoot /var/www/html~DocumentRoot /var/www/dokuwiki~g' /etc/apache2/sites-enabled/000-*.conf \
	## Copy original apache.conf and output original, replacing the /var/www tag from 'None' to 'All' back into apache.conf.
	&& cp /etc/apache2/apache2.conf /etc/apache2/apache2.conf.bak \
	&& awk '/<Directory \/var\/www\/>/,/AllowOverride None/{sub("None", "All",$0)}{print}' /etc/apache2/apache2.conf.bak > /etc/apache2/apache2.conf \
	&& rm -f /etc/apache2/apache2.conf.bak \
	&& rm -rf /var/www/html

ADD runDoku.sh /data

EXPOSE 80

CMD  /data/runDoku.sh
