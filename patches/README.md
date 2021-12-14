# Patches


### back_to_top-jquery.patch
Fixes problem where back-to-top button widget stops working under Drupal 9
However, we are using our own custom module patch as the one posted is incorrect
https://www.drupal.org/project/back_to_top/issues/3151196

### zurb-foundation-foundation-js-map.patch
Reference to a missing foundation.min.js.map file in foundation.min.js triggers errors in Drupal log
Patch removes the map file reference
https://www.drupal.org/project/zurb_foundation/issues/3183304



- clone the the module or drupal core to your computer
- Make the necessary changes
- Create the patch file
```
git diff > [/path/to/ccdhwebportal]/patches/[description of patch].patch
```

In composer.json, add a reference to the patch for deployment under the "extras" section:

```
      "extras": {
        ...
        ...
        ...
        "enable-patching": true,
        "patches": {
            "drupal/back_to_top": {
                "back_to_top-jquery": "patches/back_to_top-jquery.patch"
            },
            "drupal/zurb_foundation": {
                "zurb_foundation.js.map": "patches/zurb-foundation-foundation-js-map.patch"
            },
            "drupal/google_analytics": {
                "google_analytics-requirements": "patches/google_analytics-4.x-requirements.patch"
            }
        }
      }
```

```
# what each part means
"drupal/back_to_top": (                                        # the composer package name of the module
    "back_to_top-jquery": "patches/back_to_top-jquery.patch"   # a name for the patch (make it up) :  the path to the patch file
},
```

Composer will install the module and apply the patch as long as the versioning in the patch file and the line changes match up.  Otherwise, it will ignore the patch gracefully when it's no longer needed or out of version.

