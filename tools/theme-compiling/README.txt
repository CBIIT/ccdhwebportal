#
#  Zurb Foundation Compiling Themes
#

Zurb's stock build process with npm is riddled with problems.
Customizations have been made to the base theme, zurb_foundation
to allow for a clean build with these commands...

npm install
npm start

Copy the files from this ./theme-compiling/zurb_foundation directory into
the base directory of the base theme.

On Mac, make sure nvm is installed (```nvm use v14.16.1```) to install
node v14.16.1 (npm v6.14.12)
You may also have to run...
```
npm rebuild node-sass
```

DDev already uses these versions so you can
```
ddev ssh
cd /var/www/html/web/themes/[theme]
npm install
npm start
```

Do this once for the base theme, zurb_foundation, and once for the subtheme, ccdh_foundation

You will have to rerun npm start anytime changes are made to a *.scss file in the themes



// npm rebuild node-sass
