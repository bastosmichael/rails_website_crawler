class ApplicationController < ActionController::Base
  before_filter :restrict_access
  respond_to :json

  def index
    render text: "#{api_json}"
  end

  private

  def check_partner(access_token)
    @api_key = access_token
    return true if api_json['active'] == true
  rescue
    return false
  end

  def api_json
    @api_json ||= Record::Base.new('api-keys', api_key).data
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
