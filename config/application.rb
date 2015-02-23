require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Crawler
  class Application < Rails::Application
    config.config = config_for(:config).deep_symbolize_keys!
    config.autoload_paths += Dir[Rails.root.join('app', 'sites', '{**}')]
    config.autoload_paths += %W(#{config.root}/helpers)
  end
end
