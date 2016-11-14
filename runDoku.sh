#!/bin/bash 

if [ $(ls -A /var/www/dokuwiki/data) ]; then
        tar -xf /data/dokuwiki-stable.tgz --exclude=*lib/plugins --exclude=*conf --exclude=*data -C /var/www
else
	tar -xf /data/dokuwiki-stable.tgz -C /var/www
fi

cp -R /var/www/dokuwiki-*/* /var/www/dokuwiki
rm -f /data/dokuwiki-stable.tgz
rm -rf /var/www/dokuwiki-*

chown -R www-data:www-data /var/www/dokuwiki

apachectl -e info -D FOREGROUND

rm -- "$0"

# Start
# Check /var/www/dokuwiki/
# if empty, ignore some directories, remove tar file, remove self
# if not, extract everything.
# Remove self.
