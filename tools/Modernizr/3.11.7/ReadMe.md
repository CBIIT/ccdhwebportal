### How to Build Modernizer js lib ###
- Download latest release from Github:Modernizr/Modernizr (zip or tar.gz) and uncompress as [release dir or something deeply meaningful]
- cd [release dir]; npm install
- edit ./lib/config-all.json or copy the included config-all.json to overwrite the one in the modernizer ./lib directory
- from [release_dir] run ```npm start```
- the new modernizr js file will appear as ./dist/modernizr-build.js
- rename it: mv ./dist/modernizr-build.js ./dist/modernizr.min.js
- convert into a patchfile for Drupal. See below...


### How to Core Patch Drupal 8|9 using Git-Diff/Composer ###
- composer require cweagans/composer-patches (it's probably already in the composer.json)
- Add this block of code in composer.json under "extra" section
        "composer-exit-on-patch-failure": true,
        "patches": {
            "drupal/core": {
                "About My Patch": "patches/my-patch.patch"
            }
        }
- create 'patches' directory at root level of project (alongside config & web)
- git clone the appropriate version branch from Github:drupal/core
- ```cd core``` and edit files required for the patch
- git-diff > ../path/to/patches/my-patch.patch
- return to original drupal project site, delete the source root 'vendor' and 'web/core' directories.
- ```composer install```
- The output should show that patches have been applied
