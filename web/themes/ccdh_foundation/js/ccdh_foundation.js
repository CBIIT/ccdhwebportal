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

      // Hide the site-navigation during pageload to avoid the element artifacts from
      // flashing on the screen
      $(".site-navigation-hide-during-page-load").each(function (index, element) {
          setTimeout(function () { $(element).removeClass("site-navigation-hide-during-page-load") }, 10);
      });
    }
  };

})(jQuery, Drupal);
