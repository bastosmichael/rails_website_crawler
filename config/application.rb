require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Crawler
  class Application < Rails::Application
    config.middleware.insert_before 0, Rack::Health, :path => '/elb-status'
    config.config = config_for(:config).deep_symbolize_keys!
    require_relative '../app/sites/initializer.rb' if File.exists?('../app/sites/initializer.rb')
    config.autoload_paths += Dir[Rails.root.join('app', 'sites', '{**}')]
    config.autoload_paths += %W(#{config.root}/helpers)
  end
end
