#!/bin/bash
#
#  dump database & export configs
#
#  run:   dump.sh
#

# Switch to the ddev app dir.
CWD=`dirname "$0"`/..
cd $CWD

DB_EXPORT_DIR="./database/export"
DBFILE_PFX="ccdh_"
DBFILE_SFX=".sql"

echo "Begin Exporting Database & Config Files"

# Turn ON maint mode & clear cache.
echo "Turn ON maintenance mode"
ddev drush -y state:set system.maintenance_mode 1 --input-format=integer
echo "Clear Drupal Cache"
ddev drush -y cache:rebuild

# Export config settings to files.
ddev drush -y cex

# Dump database with timestamp.
if [ ! -z "$DB_EXPORT_DIR" ]; then
  mkdir -p $DB_EXPORT_DIR
fi
DBFILE=${DBFILE_PFX}`date +"%Y%m%d%H%M"`${DBFILE_SFX}
echo "Dump Database: $DBFILE"
ddev drush -y sql-dump > $DB_EXPORT_DIR/$DBFILE

# Turn OFF maint mode & clear cache again.
echo "Turn OFF maintenance mode"
ddev drush -y state:set system.maintenance_mode 0 --input-format=integer
echo "Clear Drupal Cache"
ddev drush -y cache:rebuild

# Done!
echo "Database & Config Files Exported"
