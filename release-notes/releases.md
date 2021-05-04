#  Release Notes - CCDH web portal (ccdhwebportal)

## Requirements as of version 1.2.0 - April/May 2021

### System Packages (installed via yum)
- patch

### Cron Setup - Apache User (DDev-Local only)
```
# Cron in drupal only runs regularly if there is consistent site traffic
# Setup with a cronjob in order to run it on a regular schedule

# Run cron every hour
0 * * * *  https://ccdhportaldev.pedscommons.org/cron/[cron-key]
```

### File System Setup (DDev-Local)
```
cp ccdhwebportal/env/.env.ddevlocal .ddev/.homeadditions/.env
```

### File System Setup (cloud servers)
```
mkdir -p /local/drupal/access
chown drupal:drupal /local/drupal/access
cp /var/www/html/ccdhwebportal/env/.env.TIER /local/drupal/access/.env
chown drupal:drupal /local/drupal/access/.env
chmod 750 /local/drupal/access/.env
```

Edit the .env changing the settings to match what was in
/var/www/html/ccdhwebportal/web/sites/default/settings/settings.local.php
This file will remain in place outside of the project directory
Drupal will access these variables via dotenv load and through env vars.
The settings.local.php is being repurposed for drupal settings in dev environments:
ddevlocal, sandbox

```
#
#  .env
#

SUBDOMAIN="ccdhportaldev"
CCDH_ENV="sandbox"

CCDH_DATABASE='[DATABASE NAME]'
CCDH_USERNAME="[USERNAME]"
CCDH_PASSWORD='[PASSWORD]'
CCDH_HOST='[HOST]'
CCDH_NAMESPACE='Drupal\\Core\\Database\\Driver\\mysql'
CCDH_DRIVER='mysql'
CCDH_PREFIX=''
CCDH_PORT=''
CCDH_HASH_SALT='[HASH_SALT]'
```
