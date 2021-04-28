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
DDEV=

echo "Begin Deploying Site::$BRANCH"

# Git pull
echo "Pull source code from origin/$BRANCH"
git pull origin $BRANCH


# Deploy .env file for DDev only
# the other .env files already exist on their respective servers
echo "Deploy .env.${ENV_TIER}"
if [ "$ENV_TIER"  == "ddevlocal" ]; then
  # For DDev, this is where dot files go to be deployed in the container
  cp -f ./env/.env.${ENV_TIER} ./.ddev/homeadditions/.env
  DDEV='ddev '
fi


# Update vendor sources
${DDEV}composer install

# Turn ON maint mode
# echo "Turn ON maintenance mode"
# ${DDEV}drush state:set system.maintenance_mode 1 --input-format=integer --quiet

# Load database
DBFILE=$DB_EXPORT_DIR/`ls ./database/export | sort -r | head -1`
echo "Loading latest database: $DBFILE"
${DDEV}drush -y sql-cli < $DBFILE

# Run Drupal database updates
echo "Running Drupal updatedb"
${DDEV}drush -y updatedb

echo "Clear Drupal Cache"
${DDEV}drush -y cache:rebuild

# Import config settings
echo "Import config settings"
# import everything from the main config directory
${DDEV}drush -y cim

# Run Drupal database updates
echo "Running Drupal updatedb"
${DDEV}drush -y updatedb

# import the environment-specific configs
echo "Import '${ENV_TIER}' config settings"
${DDEV}drush -y csim ${ENV_TIER}

# Run Drupal database updates
echo "Running Drupal updatedb"
${DDEV}drush -y updatedb

echo "Turn OFF maintenance mode"
${DDEV}drush -y state:set system.maintenance_mode 0 --input-format=integer

echo "Clear Drupal Cache"
${DDEV}drush -y cache:rebuild

# Done!
echo "Site Deployed"
