#!/bin/bash
#
#  dump database & export configs
#
#  run:   dump.sh [optional: --db|--cf]
#                 --db = dump database only
#                 --cf = dump config files only

# Switch to the ddev app dir.
CWD=`dirname "$0"`/..
cd $CWD

# optional modes: --cf, --db (defaults to ALL)
MODE=$1

DB_EXPORT_DIR="./database/export"
DBFILE_PFX="ccdh_"
DBFILE_SFX=".sql"

if [[ $MODE == '--cf' ]]; then
  echo "Begin Exporting Config Files"
elif [[ $MODE == '--db' ]]; then
  echo "Begin Exporting Database"
else
  echo "Begin Exporting Database & Config Files"
fi

# Turn ON maint mode & clear cache.
echo "Turn ON maintenance mode"
ddev drush -y state:set system.maintenance_mode 1 --input-format=integer
echo "Clear Drupal Cache"
ddev drush -y cache:rebuild

if [ -z "$MODE" ] || [[ $MODE == "--cf" ]]; then
  # Export config settings to files.
  ddev drush -y csex
fi

if [ -z "$MODE" ] || [[ $MODE == "--db" ]]; then
  # Dump database with timestamp.
  if [ ! -z "$DB_EXPORT_DIR" ]; then
    mkdir -p $DB_EXPORT_DIR
  fi
  DBFILE=${DBFILE_PFX}`date +"%Y%m%d%H%M"`${DBFILE_SFX}
  echo "Dump Database: $DBFILE"
  ddev drush -y sql-dump > $DB_EXPORT_DIR/$DBFILE
fi

# Turn OFF maint mode & clear cache again.
echo "Turn OFF maintenance mode"
ddev drush -y state:set system.maintenance_mode 0 --input-format=integer
echo "Clear Drupal Cache"
ddev drush -y cache:rebuild

# Done!
echo "Export Completed"
