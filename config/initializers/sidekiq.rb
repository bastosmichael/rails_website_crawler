require 'sidekiq'

Sidekiq.configure_server do |config|
  if Rails.configuration.config[:redis][:password].presence
    url = "redis://:#{Rails.configuration.config[:redis][:password]}@#{Rails.configuration.config[:redis][:host]}:#{Rails.configuration.config[:redis][:port]}/#{Rails.configuration.config[:redis][:database]}"
  else
    url = "redis://#{Rails.configuration.config[:redis][:host]}:#{Rails.configuration.config[:redis][:port]}/#{Rails.configuration.config[:redis][:database]}"
  end

  config.redis = { url: url, namespace: 'crawler' }
end

Sidekiq.configure_client do |config|
  if Rails.configuration.config[:redis][:password].presence
    url = "redis://:#{Rails.configuration.config[:redis][:password]}@#{Rails.configuration.config[:redis][:host]}:#{Rails.configuration.config[:redis][:port]}/#{Rails.configuration.config[:redis][:database]}"
  else
    url = "redis://#{Rails.configuration.config[:redis][:host]}:#{Rails.configuration.config[:redis][:port]}/#{Rails.configuration.config[:redis][:database]}"
  end

  config.redis = { url: url, namespace: 'crawler' }
end

SidekiqUniqueJobs.config.unique_args_enabled
