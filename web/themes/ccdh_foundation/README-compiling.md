#  Compiling ccdh_foundation theme

Updated to use latest version of node and supporting modules

On Mac, make sure nvm is installed (```nvm use v16.2.0```) to install
node v16.2.0 (npm v7.13.0)

DDev already uses these versions so you can
```
ddev ssh
cd /var/www/html/web/themes/[theme]
npm install
npm start
```

Do this once for the subtheme, ccdh_foundation

You will have to rerun npm start anytime changes are made to a *.scss file in the inherited /scss dir

