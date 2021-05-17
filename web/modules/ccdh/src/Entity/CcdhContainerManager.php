<?php
namespace Drupal\ccdh\Entity;


use Drupal\Core\Config\Entity\ConfigEntityBase;
use Drupal\Core\Config\Entity\ConfigEntityInterface;
use Drupal\google_tag\Entity\Container;
use Drupal\google_tag\Entity\ContainerManager;


/**
 * Class:  CcdhContainerManager.
 *
 * Extends ContainerManager class from Google_tag module.
 * We're overriding so that we can call $container->noscriptTag()
 * with a different weight than the default -10.
 */
class CcdhContainerManager extends ContainerManager {

  /**
   * {@inheritdoc}
   */
  public function getNoScriptAttachments(array &$page) {
    $ids = $this->loadContainerIDs();
    $containers = $this->entityTypeManager->getStorage('google_tag_container')->loadMultiple($ids);
    foreach ($containers as $container) {
      if (!$container->insertSnippet()) {
        continue;
      }

      $page += $container->noscriptTag('noscript', -100);
    }
  }

}
