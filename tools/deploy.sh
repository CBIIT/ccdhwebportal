#!/bin/bash
#
#  deploy source code branch, import database, load config files
#
#  run:   deploy.sh develop*    # *=optional
#

# switch to the ddev app dir
CWD=`dirname "$0"`/..
cd $CWD

BRANCH=
BRANCHES=('develop' 'master')
if [ -z "$1" ]; then
  echo "Please specify a git branch to deploy"
  exit 1
elif echo ${BRANCHES[@]} | grep -q -w "$1"; then
  BRANCH=$1
  echo "Branch:  $BRANCH"
else
  echo "Please specify a git branch to deploy.  '$1' is not valid."
  exit 1
fi

DB_EXPORT_DIR="./database/export"

echo "Begin Deploying Site::$BRANCH"

# Git pull
echo "Pull source code from origin/$BRANCH"
git pull origin $BRANCH

# Update vendor sources
ddev composer install

# Turn ON maint mode
# echo "Turn ON maintenance mode"
# ddev drush state:set system.maintenance_mode 1 --input-format=integer --quiet

# Load database
DBFILE=$DB_EXPORT_DIR/`ls ./database/export | sort -r | head -1`
echo "Loading latest database: $DBFILE"
ddev drush -y sql-cli < $DBFILE

# Import config settings
echo "Import config settings"
ddev drush -y cim

# Run Drupal database updates
echo "Running Drupal updatedb"
ddev drush -y updatedb

echo "Clear Drupal Cache"
ddev drush -y cache:rebuild

echo "Turn OFF maintenance mode"
ddev drush -y sset system.maintenance_mode 0 --input-format=integer
ddev drush -y cache:rebuild

# Done!
echo "Site Deployed"
