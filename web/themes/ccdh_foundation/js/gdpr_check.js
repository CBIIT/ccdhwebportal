/**
 * @file
 * Placeholder file for custom sub-theme behaviors.
 *
 */
(function ($, Drupal) {

  Drupal.behaviors.checkGDPR = {
    attach: function (context, settings) {

      // eu_cookie_compliance already reloads after consent has been revoked.
      // we need to reload when consent has been granted in order to enable analytics
      // #sliding-popup and it's child elements are dynamic elements

      $('body').on('click', '#sliding-popup .agree-button', function() {
          console.log('tracking enabled');
          location.reload();
      })

    }
  };

})(jQuery, Drupal);
