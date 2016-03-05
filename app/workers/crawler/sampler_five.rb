class Crawler::SamplerFive < Crawler::Sampler
  TYPE = 'ScrimperFive'

  sidekiq_options queue: :sampler_five,
                  retry: true,
                  backtrace: true,
                  unique: :until_and_while_executing,
                  unique_expiration: 120 * 60
end
