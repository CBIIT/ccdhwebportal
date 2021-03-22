#!/bin/bash
#
#  deploy source code branch, import database, load config files
#
#  run:   deploy.sh develop*    # *=optional
#

# switch to the ddev app dir
cd ..

BRANCH='master'
if [ ! -z "$1" ] && [[ $1 == 'develop' ]]; then
  BRANCH=$1
fi

DB_EXPORT_DIR="./database/export"

echo "Begin Deploying Site::$BRANCH"

# Git pull
echo "Pull source code from origin/$BRANCH"
git pull origin $BRANCH

# Turn ON maint mode.
echo "Turn ON maintenance mode"
ddev drush sset system.maintenance_mode 1 --input-format=integer

# Update vendor sources
ddev composer install

# Load database
DBFILE=$DB_EXPORT_DIR/`ls database/export | sort -r | head -1`
echo "Loading latest database: $DBFILE"
ddev drush -y sql-cli < $DBFILE

# Import config settings
echo "Import config settings"
ddev drush -y cim

# Run Drupal database updates
echo "Run Drupal updatedb"
ddev drush -y updatedb

echo "Clear Drupal Cache"
ddev drush -y cache:rebuild

echo "Turn OFF maintenance mode"
ddev drush -y sset system.maintenance_mode 0 --input-format=integer
ddev drush -y cache:rebuild

# Done!
echo "Site Deployed"
