#!/bin/bash
#
#  deploy source code branch, import database, load config files
#
#  run:   deploy.sh develop*    # *=optional
#

# switch to the ddev app dir
CWD=`dirname "$0"`/..
cd $CWD

USAGE="deploy.sh [master|develop] [production|stage|qa|dev|sandbox|ddevlocal]"

BRANCH=
BRANCHES=('develop' 'master')
if [ -z "$1" ]; then
  echo "Please specify a git branch to deploy"
  echo "$USAGE"
  exit 1
elif echo ${BRANCHES[@]} | grep -q -w "$1"; then
  BRANCH=$1
  echo "Branch:  $BRANCH"
else
  echo "Please specify a git branch to deploy.  '$1' is not valid."
  echo "$USAGE"
  exit 1
fi

ENV_TIER=
ENV_TIERS=('production' 'stage' 'qa' 'dev' 'sandbox' 'ddevlocal')
if [ -z "$2" ]; then
  echo "Please indicate the deployment environment"
  echo "$USAGE"
  exit 1
elif echo ${ENV_TIERS[@]} | grep -q -w "$2"; then
  ENV_TIER=$2
  echo "Env:  $ENV_TIER"
else
  echo "Please indicate the deployment environment.  '$2' is not valid."
  echo "$USAGE"
  exit 1
fi

DB_EXPORT_DIR="./database/export"

echo "Begin Deploying Site::$BRANCH"

# Git pull
echo "Pull source code from origin/$BRANCH"
git pull origin $BRANCH


# Deploy .env file
echo "Deploy .env.${ENV_TIER}"
if [ "$ENV_TIER"  == "ddevlocal" ]; then
  # For DDev, this is where dot files go to be deployed in the container
  cp -f ./env/.env.${ENV_TIER} ./.ddev/homeadditions/.env
else
  cp -f ./env/.env.${ENV_TIER} ./.env
fi


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
# import everything from the main config directory
ddev drush -y cim
# import the environment-specific configs
ddev drush -y csim ${ENV_TIER}

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
