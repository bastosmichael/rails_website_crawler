class ApplicationController < ActionController::Base
  include CountsHelper
  before_filter :restrict_access
  before_filter :remove_params
  respond_to :json

  def index
    render json: api_json.merge(counts).to_json
  end

  private

  def counts
    { available: Rails.configuration.config[:admin][:api_containers].map {|c| { c => pretty_integer(count_containers(c)) } }.inject(:merge),
      indexing: pretty_integer(Sidekiq::Queue.new('mapper').size),
      processing: pretty_integer(Sidekiq::Queue.new('scrimper').size),
      pending: pretty_integer((Sidekiq::Queue.new('sitemapper').size + Sidekiq::Queue.new('sitemapper_alternate').size) * 50_000) }
  end

  def count_containers container
    Elasticsearch::Model.client.search(index: container, body: { aggs: { names_count: { value_count: { field: 'name' } } } })['aggregations']['names_count']['value']
  end

  def remove_params
    params.delete(:action)
    params.delete(:controller)
    params.delete(:format)
    params.delete(:access_token) if params[:access_token]
  end

  def check_partner(access_token)
    @api_key = access_token
    return true if api_json['active'] == true
  rescue
    return false
  end

  def api_json
    @api_json ||= api_record.data
  end

  def api_record
    @api_record ||= Record::Base.new('api-keys', api_key)
  end

  attr_reader :api_key

  def restrict_access
    return if check_partner params[:access_token] if params[:access_token]
    authenticate_or_request_with_http_token do |token, _options|
      return if check_partner token
    end
  end
end
