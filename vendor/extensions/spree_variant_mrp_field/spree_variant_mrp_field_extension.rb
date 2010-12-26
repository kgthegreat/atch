# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

class SpreeVariantMrpFieldExtension < Spree::Extension
  version "1.0"
  description "Describe your extension here"
  url "http://yourwebsite.com/spree_variant_mrp_field"

  # Please use spree_variant_mrp_field/config/routes.rb instead for extension routes.

  # def self.require_gems(config)
  #   config.gem "gemname-goes-here", :version => '1.2.3'
  # end

  def activate

    Variant.additional_fields += [ { :name => 'mrp', :only => [:variant], :format => "%.2f"}]
    # make your helper avaliable in all views
    # Spree::BaseController.class_eval do
    #   helper YourHelper
    # end
  end
end
