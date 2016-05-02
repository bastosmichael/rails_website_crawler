class Crawler::ScrimperEight < Crawler::Scrimper
  sidekiq_options queue: :scrimper_eight,
                  retry: true,
                  backtrace: true,
                  unique: :until_and_while_executing,
                  unique_expiration: 120 * 60
end
