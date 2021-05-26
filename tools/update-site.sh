#!/bin/bash
#
# update-site.sh
#

SITE="dev"

# archive the sites dir just in case
echo "Update CCDH Web Portal site"

echo "Archive sites"
mkdir -p /local/drupal/backups/sites-archive
tar -czvf /local/drupal/backups/sites-archive/sites.`date +"%Y%m%d_%H%M%S"`.tgz /local/drupal/harmonization/web/sites

echo "Update code & run deploy script"
cd /local/drupal/harmonization
git pull
git reset --hard origin/master
git pull
./tools/deploy.sh master $SITE

echo "Done!"

