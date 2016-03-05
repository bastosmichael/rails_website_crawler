class Crawler::SamplerTwo < Crawler::Sampler
  TYPE = 'ScrimperTwo'

  sidekiq_options queue: :sampler_two,
                  retry: true,
                  backtrace: true,
                  unique: :until_and_while_executing,
                  unique_expiration: 120 * 60
end
