<?php

include __DIR__ . '/settings/settings.shared.php';

// Automatically generated include for settings managed by ddev.
$ddev_settings = dirname(__FILE__) . '/settings.ddev.php';
if (is_readable($ddev_settings) && getenv('IS_DDEV_PROJECT') == 'true') {
  require $ddev_settings;
}
