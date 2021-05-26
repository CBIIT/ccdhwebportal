#!/bin/bash
#
# update-site.sh
#

SITE="sandbox"

# archive the sites dir just in case
echo "Update CCDH Web Portal site"

echo "Archive sites"
mkdir -p /var/www/html/sites-archive
tar -czvf /var/www/html/sites-archive/sites.`date + "%Y%m%d_%H%M%S"`.tgz /var/www/html/ccdhwebportal/web/sites

echo "Update code & run deploy script"
cd /var/www/html/ccdhwebportal
git pull
git reset --hard origin/master
git pull
./tools/deploy.sh master $SITE

echo "Done!"

