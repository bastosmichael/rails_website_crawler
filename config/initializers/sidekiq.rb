require 'sidekiq'
require 'sidekiq/web'

Sidekiq::Web.use(Rack::Auth::Basic) do |user, password|
  user = Rails.configuration.config['admin']['username']
  password = Rails.configuration.config['admin']['password']
end

Sidekiq.configure_server do |config|
  config.redis = { url: "redis://#{Rails.configuration.config['redis']['address']}:#{Rails.configuration.config['redis']['port']}/#{Rails.configuration.config['redis']['database']}", namespace: 'crawler' }
end

Sidekiq.configure_client do |config|
  config.redis = { url: "redis://#{Rails.configuration.config['redis']['address']}:#{Rails.configuration.config['redis']['port']}/#{Rails.configuration.config['redis']['database']}", namespace: 'crawler' }
end
