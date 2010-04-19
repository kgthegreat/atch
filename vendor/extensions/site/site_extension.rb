# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

class SiteExtension < Spree::Extension
  version "1.0"
  description "Describe your extension here"
  url "http://yourwebsite.com/site"

  # Please use site/config/routes.rb instead for extension routes.

  # def self.require_gems(config)
  #   config.gem "gemname-goes-here", :version => '1.2.3'
  # end

  def activate

    AppConfiguration.class_eval do
      preference :allow_ssl_in_production, :boolean, :default => false
    end

    Spree::Config.set(:logo => '/images/attachawal_resized.png')
    # make your helper avaliable in all views
    # Spree::BaseController.class_eval do
    #   helper YourHelper
    # end
    Checkout.state_machines[:state] = StateMachine::Machine.new(Checkout, :initial => 'address') do
      after_transition :to => 'complete', :do => :complete_order
#      before_transition :to => 'complete', :do => :process_payment
      event :next do
        transition :to => 'complete', :from => 'address'
      end
    end

    CheckoutsController.class_eval do
      def clear_payments_if_in_payment_state
      end

      def object_params
      end
    end

  end
end
