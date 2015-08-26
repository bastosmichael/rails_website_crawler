source 'https://rubygems.org'

gem 'rails', '4.2.3'
gem 'responders'
gem 'sqlite3'

gem 'mina'
# gem 'mina-puma', :require => false
gem 'mina-sidekiq'

gem 'oj'
gem 'oj_mimic_json'

gem 'awesome_print'
gem 'progress'

gem 'nokogiri'
gem 'mechanize'
gem 'social_shares'
gem 'user-agent-randomizer'

gem 'selenium-webdriver'
gem 'headless'
gem 'rmagick'

gem 'vcr'
gem 'typhoeus'
gem 'fog'

gem 'redis-objects'
gem 'redis-rails'
gem 'elasticsearch-model'

gem 'dalli'

gem 'sidekiq'
gem 'sidekiq-unique-jobs'
gem 'sidetiq'
gem 'sidekiq-statistic'

gem 'sinatra', require: false

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', '~> 0.4.0'
end

group :development, :test do
  gem 'thin'
end

group :development do
  gem 'pry-rails'
  gem 'spring'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'meta_request'
  gem 'quiet_assets'
  gem 'rails_layout'
  gem 'rubocop', require: false
  gem 'guard-test', require: false
  gem 'guard-livereload', require: false
  gem 'guard-rails', require: false
  gem 'guard-sidekiq', require: false
  gem 'rack-livereload'
  gem 'mock_redis'
end

group :production do
  gem 'puma'
end
