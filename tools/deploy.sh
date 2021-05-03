#!/bin/bash
#
#  deploy source code branch, import database, load config files
#
#  run from project root:   ./tools/deploy.sh [branch] [tier]
#

# switch to the ddev app dir
CWD=`dirname "$0"`/..
cd $CWD

USAGE="deploy.sh [master|develop] [production|stage|qa|dev|sandbox|ddevlocal]"

DB_EXPORT_DIR=
DDEV=

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


echo "Begin Deploying Site::$BRANCH"

if [ "$ENV_TIER"  == "ddevlocal" ]; then
  # Deploy .env file for DDev only
  # the other .env files already exist on their respective servers
  echo "Deploy .env.${ENV_TIER}"

  # Git pull, keep local changes
  echo "Pull source code from origin/$BRANCH"
  git pull origin $BRANCH

  # For DDev, this is where dot files go to be deployed in the container
  cp -f ./env/.env.${ENV_TIER} ./.ddev/homeadditions/.env
  DDEV='ddev '
  DB_EXPORT_DIR="./database/export"

elif [ "$ENV_TIER"  == "sandbox" ]; then

  # Git pull, keep local changes in the even there are uncommitted image files
  echo "Pull source code from origin/$BRANCH"
  git reset --keep origin/$BRANCH
  git pull origin $BRANCH

  # don't overwrite the sandbox database
  DB_EXPORT_DIR=''

else
  # nci tiers

  # Git pull the database repo
  DB_EXPORT_DIR="/local/home/drupal/ccdh_webportal_db_backups"
  # git -C doesn't work on versions, have to cd into the repo
  PROJ_DIR=`pwd`
  cd $DB_EXPORT_DIR
  git checkout main
  git pull origin main

  # Git pull the project branch, discard local changes
  echo "Pull source code from origin/$BRANCH"
  cd $PROJ_DIR
  git reset --hard origin/$BRANCH
  git pull origin $BRANCH
fi


# Update vendor sources
${DDEV}composer install

# Turn ON maint mode -- don't do this, causing more problems than it's worth
# echo "Turn ON maintenance mode"
# ${DDEV}drush state:set system.maintenance_mode 1 --input-format=integer --quiet

if [ ! -z "$DB_EXPORT_DIR" ]; then
  # Load database
  DBFILE=`ls $DB_EXPORT_DIR/*.sql | sort -r | head -1`
  if [ ! -z "DBFILE" ]; then
    echo "Loading latest database: $DBFILE"
    ${DDEV}drush -y sql-cli < $DBFILE
  else
    echo "Unable to find database to load."
  fi
fi

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
