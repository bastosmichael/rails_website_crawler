class Crawler::SpiderTwo < Crawler::Spider
  sidekiq_options queue: :spider_two,
                  retry: true,
                  backtrace: true,
                  unique: :until_and_while_executing,
                  unique_expiration: 120 * 60 * 365

  def next_type
    @type ||= 'SpiderTwo'
  end
end
