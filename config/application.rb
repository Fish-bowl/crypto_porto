require_relative 'boot'

require "rails"
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
Bundler.require(*Rails.groups)

module CryptoPortfolio
  class Application < Rails::Application
    config.load_defaults 5.2
    config.api_only = true
    config.middleware.insert_before 0, Rack::Cors do 
      allow do
        orgins '*'
        resouce '*', 
          methods: [get, :post, :put, :delete]
          expose: ['access-tolen', 'client', 'uid', 'expiry']
      end
      
  end
end
