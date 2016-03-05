class Crawler::SamplerOne < Crawler::Sampler
  TYPE = 'ScrimperOne'

  sidekiq_options queue: :sampler_one,
                  retry: true,
                  backtrace: true,
                  unique: :until_and_while_executing,
                  unique_expiration: 120 * 60
end
