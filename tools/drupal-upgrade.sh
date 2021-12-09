#!/bin/bash
#
#  Upgrade Drupal
#
#  run from project root:   ./tools/drupal-upgrade.sh
#  run in the DDevLocal development environment ONLY
#
#  module upgrades can be done using composer
#  composer update drupal/[module name]

echo "Begin: Drupal Core Upgrade"
composer update drupal/core "drupal/core-*" --with-all-dependencies

ddev drush -y updatedb
ddev drush -y cache:rebuild

echo "Drupal Core Upgrade... Completed!"
