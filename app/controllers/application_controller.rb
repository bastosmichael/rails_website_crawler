class ApplicationController < ActionController::Base
  before_filter :restrict_access
  after_filter :track_usage
  respond_to :json

  def index
    render json: api_json.to_json
  end

  private

  def track_usage
    if api_json['last_used'] == Date.today.to_s
      api_json['api_usage'] = api_json['api_usage'] + 1
    else
      api_json['last_used'] = Date.today.to_s
      api_json['api_usage'] = 0
    end
    api_record.data = api_json
  end

  def check_partner(access_token)
    @api_key = access_token
    return true if api_json['active'] == true && api_usage <= api_usage_cap
  rescue
    return false
  end

  def api_usage_cap
    api_json['api_usage_cap']
  end

  def api_usage
    api_json['api_usage']
  end

  def api_json
    @api_json ||= api_record.data
  end

  def api_record
    @api_record ||= Record::Base.new('api-keys', api_key)
  end

  def api_key
    @api_key
  end

  def restrict_access
    return if check_partner params[:access_token] if params[:access_token]
    authenticate_or_request_with_http_token do |token, _options|
      return if check_partner token
    end
  end
end
