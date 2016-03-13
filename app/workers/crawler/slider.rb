class Crawler::Slider < Crawler::Sampler
  sidekiq_options queue: :slider,
                  retry: true,
                  backtrace: true,
                  unique: :until_and_while_executing,
                  unique_expiration: 120 * 60
end
