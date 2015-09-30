class V1::AccessController < ApplicationController
  include CountsHelper
  before_filter :restrict_access
  before_filter :remove_params

  def index
    respond_to do |format|
      format.json { json_response(200, api_data.merge(counts)) }
      format.xml { xml_response(200, api_data.merge(counts)) }
    end
  end

  private

  def counts
    { available: count_indexes,
      indexing: pretty_integer(count_mappers),
      processing: pretty_integer(count_scrimpers),
      pending: pretty_integer((count_sitemappers) * 50_000) }
  end

  def count_indexes
    Rails.configuration.config[:admin][:api_containers]
      .map { |c| [c, count_containers(Rails.env + '-' + c) ] }
        .sort_by {|array| array.last }.reverse
          .map {|array| { array.first => pretty_integer(array.last) } }.inject(:merge)
  end

  def count_mappers
    Sidekiq::Queue.new('mapper').size
  rescue Redis::CannotConnectError => e
    0
  end

  def count_scrimpers
    Sidekiq::Queue.new('scrimper').size +
      Sidekiq::Queue.new('scrimper_one').size +
      Sidekiq::Queue.new('scrimper_two').size +
      Sidekiq::Queue.new('scrimper_three').size +
      Sidekiq::Queue.new('scrimper_four').size +
      Sidekiq::Queue.new('scrimper_five').size
  rescue Redis::CannotConnectError => e
    0
  end

  def count_sitemappers
    Sidekiq::Queue.new('sitemapper').size +
      Sidekiq::Queue.new('sitemapper_one').size +
      Sidekiq::Queue.new('sitemapper_two').size +
      Sidekiq::Queue.new('sitemapper_three').size +
      Sidekiq::Queue.new('sitemapper_four').size +
      Sidekiq::Queue.new('sitemapper_five').size
  rescue Redis::CannotConnectError => e
    0
  end

  def count_containers(container)
    Elasticsearch::Model.client.count(index: container)['count']
  rescue Elasticsearch::Transport::Transport::Errors => e
    0
  end

  def remove_params
    params.delete(:action)
    params.delete(:controller)
    params.delete(:format)
    params.delete(:access_token) if params[:access_token]
  end

  def track_usage
    if api_data['api_last_used'] == Date.today.to_s
      api_data['api_daily_usage'] = api_data['api_daily_usage'] + 1
    else
      api_data['api_last_used'] = Date.today.to_s
      api_data['api_daily_usage'] = 0
    end
    api_record.data = api_data
  end

  def check_partner(access_token)
    @api_key = access_token
    if api_active && api_usage_cap.nil?
      return true
    elsif api_active && api_usage_cap
      track_usage
      return true if api_active && api_daily_usage < api_usage_cap
    end
  rescue
    return false
  end

  def api_active
    api_data['active'] == true
  end

  def api_usage_cap
    api_data['api_usage_cap']
  end

  def api_daily_usage
    api_data['api_daily_usage']
  end
end
