require 'sidekiq'

Sidekiq.configure_server do |config|
  config.redis = { url: "redis://:#{Rails.configuration.config[:redis][:password]}@#{Rails.configuration.config[:redis][:host]}:#{Rails.configuration.config[:redis][:port]}/#{Rails.configuration.config[:redis][:database]}", namespace: 'crawler' }
end

Sidekiq.configure_client do |config|
  config.redis = { url: "redis://:#{Rails.configuration.config[:redis][:password]}@#{Rails.configuration.config[:redis][:host]}:#{Rails.configuration.config[:redis][:port]}/#{Rails.configuration.config[:redis][:database]}", namespace: 'crawler' }
end

SidekiqUniqueJobs.config.unique_args_enabled
