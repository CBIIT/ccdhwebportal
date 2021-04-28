<?php

namespace Ccdh\Libraries\ccdh_lib;

use Dotenv\Dotenv;
use Dotenv\Exception\InvalidPathException;

/**
 * Class: ServerEnv.
 *
 * Detects the server environment tier.
 */
class ServerEnv {

  /**
   *  load the .env from outside of web root
   */

  /**
   * Function: loadSettings.
   *
   * Determine the environment tier from the hostname.
   * Store the env setting in PHP env.
   */
  public static function loadSettings() {
    try {
      $filepath = DRUPAL_ROOT . '/../../access';
      if (TRUE == getenv('IS_DDEV_PROJECT')) {
        $filepath = DRUPAL_ROOT . '/../.ddev/homeadditions';
      }
      $dotenv = Dotenv::createImmutable($filepath);
      $dotenv->load();

      putenv("CCDH_ENV=" . $_ENV['CCDH_ENV']);
      putenv("CCDH_SUBDOMAIN=" . $_ENV['CCDH_SUBDOMAIN']);

      if (FALSE == getenv('IS_DDEV_PROJECT')) {
        // DDEV projects have this values handled by DDEV
        // in a separate settings file.
        putenv("CCDH_DATABASE=" . $_ENV['CCDH_DATABASE']);
        putenv("CCDH_USERNAME=" . $_ENV['CCDH_USERNAME']);
        putenv("CCDH_PASSWORD=" . $_ENV['CCDH_PASSWORD']);
        putenv("CCDH_PREFIX=" . $_ENV['CCDH_PREFIX']);
        putenv("CCDH_HOST=" . $_ENV['CCDH_HOST']);
        putenv("CCDH_PORT=" . $_ENV['CCDH_PORT']);
        putenv("CCDH_NAMESPACE=" . $_ENV['CCDH_NAMESPACE']);
        putenv("CCDH_DRIVER=" . $_ENV['CCDH_DRIVER']);
        putenv("CCDH_HASH_SALT=" . $_ENV['CCDH_HASH_SALT']);
      }

    } catch (InvalidPathException $e) {
      print "<h2>Settings file not found.</h2><p>{$e->getMessage()}</p>";
      return FALSE;
    }
    return TRUE;
  }

}
