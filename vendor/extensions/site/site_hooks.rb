class SiteHooks < Spree::ThemeSupport::HookListener

  insert_after :inside_head, 'shared/styles'
  insert_after :inside_head, 'shared/js'
  replace :taxon_sidebar_navigation, 'shared/sidebar_atch'

  replace :homepage_sidebar_navigation, 'shared/sidebar_atch'


  #replace :inside_cart_form, 'shared/some_cart'

  #insert_before :homepage_sidebar_navigation,  'shared/faq'
  insert_after :homepage_sidebar_navigation,  'shared/omnicart_atch'
  insert_after :taxon_sidebar_navigation,  'shared/omnicart_atch'

#  insert_before :homepage_products, :text => "<p><h4>We are gearing up to serve you better. Thanks to all the customers who took part in the dry runs.<br> We are not accepting orders right now. Stay tuned for more and Happy Diwali :)</h4></p>"

#  insert_before :homepage_products, 'shared/faq'
#  insert_before :homepage_products, 'shared/homepage'
#  insert_before :homepage_products, 'shared/top_offers'
#  insert_before :homepage_products do
 #   '<img src="/images/header.png"/>'
 #   end
  insert_before :homepage_products, 'shared/info'

 # remove :sidebar
 # remove :homepage_products
  #
  # In this file you can modify the content of the hooks available in the default templates
  # and avoid overriding a template in many situations. Multiple extensions can modify the
  # same hook, the changes being applied cumulatively based on extension load order
  #
  # Most hooks are defined with blocks so they span a region of the template, allowing content
  # to be replaced or removed as well as added to.
  #
  # Usage
  #
  # The following methods are available
  #
  # * insert_before
  # * insert_after
  # * replace
  # * remove
  #
  # All accept a block name symbol followed either by arguments that would be valid for 'render'
  # or a block which returns the string to be inserted. The block will have access to any methods
  # or instance variables accessible in your views
  #
  # Examples
  #
  #

  # insert_before :homepage_products, :text => "<h1>Welcome to the store!<br> We are currently gearing up to serve you.<br> Good things coming your way very soon. :) </h1>"
  #insert_after :homepage_products, 'shared/offers' # renders a partial
  #   replace :taxon_sidebar_navigation, 'shared/my_sidebar
  #
  # adding a link below product details:
  #
  #   insert_after :product_description do
  #    '<p>' + link_to('Back to products', products_path) + '</p>'
  #   end
  #
  # adding a new tab to the admin navigation
  #
  #   insert_after :admin_tabs do
  #     tab(:taxonomies)
  #   end
  #

end
