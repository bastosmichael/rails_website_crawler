class Crawler::SpiderFour < Crawler::Spider
  sidekiq_options queue: :spider_four,
                  retry: true,
                  backtrace: true,
                  unique: :until_and_while_executing,
                  unique_expiration: 120 * 60
end
