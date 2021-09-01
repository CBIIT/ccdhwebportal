# Patches
Module patches are failing -- do not use for now

### back_to_top-jquery.patch
Fixes problem where back-to-top button widget stops working under Drupal 9
However, we are using our own custom module patch as the one posted is incorrect
https://www.drupal.org/project/back_to_top/issues/3151196

### zurb-foundation-foundation-js-map.patch
Reference to a missing foundation.min.js.map file in foundation.min.js triggers errors in Drupal log
Patch removes the map file reference
https://www.drupal.org/project/zurb_foundation/issues/3183304
