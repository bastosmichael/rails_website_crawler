Redis.current = Redis.new(host: Rails.configuration.config[:redis][:host], port: Rails.configuration.config[:redis][:port], password: Rails.configuration.config[:redis][:password])
