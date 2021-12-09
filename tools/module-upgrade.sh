#!/bin/bash
#
#  Upgrade Modules
#
#  run from project root:   ./tools/module-upgrade.sh [module name] [module name] ...
#
#  [module name] without the "drupal/" prefix, versions allowed,
#     anything other than
#     the standard "drupal/my-module" should not use this script
#  run in the DDevLocal development environment ONLY
#

echo "Begin: Drupal Module Upgrade"

for module in "$@"; do
  # Loop through each module name and upgrade
  echo "Upgrade $module"
  composer update "drupal/${module}"
done

ddev drush -y updatedb
ddev drush -y cache:rebuild

echo "Drupal Module Upgrade... Completed!"
