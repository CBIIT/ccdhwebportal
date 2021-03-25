# CCDH Web Portal
### (ccdhwebportal)

### Deploy the Site
1. Git clone/pull this repo
2. Git clone/pull the repo for the database backup files
3. Place the preferred *.sql backup file in ccdhwebportal/databases/export
4. ```cd ccdhwebportal```
5. ```./tools/deploy.sh [BRANCH] ``` # replace BRANCH with ( develop | master )
6.  Visit the site in your web browser

### Dump/Archive the Site
1. ```cd ccdhwebportal```
2. ```./tools/dump.sh```
3. A new database dump file will be created and any config file changes will be exported.
4. Copy the latest database *.sql from ccdhwebporta/databases/export into CCDH Webportal Database Backups and commit the new file.  Sql files do not get commmitted to this repo.
5. Commit the updated config files to this repo.
