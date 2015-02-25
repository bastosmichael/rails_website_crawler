class ApplicationController < ActionController::Base
  respond_to :json

  def index
    redirect_to Rails.configuration.config[:admin][:docs] || 'https://github.com/bastosmichael/skynet'
  end

  private

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
