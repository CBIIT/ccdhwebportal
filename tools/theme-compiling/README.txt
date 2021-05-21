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

Using ddev-local, ddev ssh to use the linux system.
Do the build.
The files will be written to the proper locations in the base dir.
Commit them to the git repo.

As of this writing, the build WILL NOT WORK on Mac OS Big Sur.
ddev uses node v14.16.1 and npm v6.14.12.
This seems to be a successful combination.


Do the same for the ccdh_foundation subtheme.
