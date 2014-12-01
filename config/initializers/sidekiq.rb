require 'sidekiq'
require 'sidekiq/web'

Sidekiq::Web.use(Rack::Auth::Basic) do |user, password|
  [user, password] == %w(admin password)
end

Sidekiq.configure_server do |config|
  config.redis = { url: "redis://#{SETTINGS[:redis][:address]}:#{SETTINGS[:redis][:port]}/#{SETTINGS[:redis][:database]}"}#, namespace: 'crawler' }
end

Sidekiq.configure_client do |config|
  config.redis = { url: "redis://#{SETTINGS[:redis][:address]}:#{SETTINGS[:redis][:port]}/#{SETTINGS[:redis][:database]}"}#, namespace: 'crawler' }
end
