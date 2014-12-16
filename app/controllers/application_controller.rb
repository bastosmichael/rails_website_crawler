class ApplicationController < ActionController::Base
  before_filter :restrict_access
  respond_to :json

  def index
    render text: "#{api_json}"
  end

  private

  def check_partner(access_token)
    @api_json ||= Record::Base.new('api-keys', access_token).data
    # api_json[:active] == true
  end

  def api_json
    @api_json
  end

  def api_key
    @api_key
  end

  def restrict_access
    @api_key = params[:access_token]
    authenticate_or_request_with_http_token do |token, _options|
      if check_partner
        return true
      elsif check_partner token
        return true
      else
        false
      end
    end
  end
end
