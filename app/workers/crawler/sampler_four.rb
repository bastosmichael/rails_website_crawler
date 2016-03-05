class Crawler::SamplerFour < Crawler::Sampler
  TYPE = 'ScrimperFour'

  sidekiq_options queue: :sampler_four,
                  retry: true,
                  backtrace: true,
                  unique: :until_and_while_executing,
                  unique_expiration: 120 * 60

end
