class Crawler::ScrimperSix < Crawler::Scrimper
  sidekiq_options queue: :scrimper_six,
                  retry: true,
                  backtrace: true,
                  unique: :until_and_while_executing,
                  unique_expiration: 120 * 60
end
