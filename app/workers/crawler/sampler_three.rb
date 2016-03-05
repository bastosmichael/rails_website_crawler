class Crawler::SamplerThree < Crawler::Sampler
  TYPE = 'ScrimperThree'

  sidekiq_options queue: :sampler_three,
                  retry: true,
                  backtrace: true,
                  unique: :until_and_while_executing,
                  unique_expiration: 120 * 60
end
