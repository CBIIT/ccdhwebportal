#!/bin/bash
#
#  Loads the database in to the ddev site
#
#  run from project root:   ./tools/load.sh
#

# switch to the ddev app dir
CWD=`dirname "$0"`/..
cd $CWD

USAGE="load.sh"

DB_EXPORT_DIR=
DDEV=


# echo "Begin Loading Database"

DDEV='ddev '
DB_EXPORT_DIR="./database/export"


if [ -e "$DB_EXPORT_DIR" ]; then
  # Load database
  DBFILE=`ls $DB_EXPORT_DIR/*.sql | sort -r | head -1`
  if [ ! -z "DBFILE" ]; then
    echo "Loading latest database: $DBFILE"
    ${DDEV}drush -y sql-cli < $DBFILE
  else
    echo "Unable to find database to load."
  fi
else
  echo "./database/export directory not found."
fi

echo "Done"
