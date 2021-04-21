/**
 * @file
 * Placeholder file for custom sub-theme behaviors.
 *
 */
(function ($, Drupal) {

  Drupal.behaviors.ccdhFoundation = {
    attach: function (context, settings) {
      $('li.is-submenu-item a', context).each(function() {
        if ( ( $(this).attr('target') ==  '_blank' ) && (! $(this).children('.fa-external-link').length) ) {
          $(this).append('<i class="fa fa-external-link" aria-label="external link"></i>');
        }
      })
    }
  };

})(jQuery, Drupal);
