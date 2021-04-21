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
      $filepath = DRUPAL_ROOT . '/..';
      if (getenv('IS_DDEV_PROJECT')) {
        $filepath = DRUPAL_ROOT . '/../.ddev/homeadditions';
      }
      $dotenv = Dotenv::createImmutable($filepath);
      $dotenv->load();
    } catch (InvalidPathException $e) {
      print "<h2>Settings file not found.</h2><p>{$e->getMessage()}</p>";
      return FALSE;
    }
    return TRUE;
  }

}
