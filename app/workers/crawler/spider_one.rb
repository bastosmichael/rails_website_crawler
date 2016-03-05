class Crawler::SpiderOne < Crawler::Spider
  sidekiq_options queue: :spider_one,
                  retry: true,
                  backtrace: true,
                  unique: :until_and_while_executing,
                  unique_expiration: 120 * 60
end
