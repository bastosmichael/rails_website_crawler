class ApplicationController < ActionController::Base
  include CountsHelper
  before_filter :restrict_access
  before_filter :remove_params
  respond_to :json

  def index
    respond_to do |format|
      format.json { json_response(200, api_data.merge(counts)) }
      format.xml { xml_response(200, api_data.merge(counts)) }
    end

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
    return true if api_data['active'] == true
  rescue
    return false
  end

  def api_data
    @api_data ||= api_record.data
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

  def errors_response(error_messages)
    error_messages = Array(error_messages)
    {
      error: {
        messages: error_messages.map { |message| { message: message }}
      }
    }
  end

  def json_response(status_code, json = {})
    render json: {
      response: {
        status: status_code,
      }
    }.merge!(json), status: status_code
  end

  def xml_response(status_code, xml = {})
    render xml: {
      response: {
        status: status_code,
      }
    }.merge!(xml), status: status_code
  end
end
