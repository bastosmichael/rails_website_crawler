class ApplicationController < ActionController::Base
  respond_to :json

  def index
    redirect_to Rails.configuration.config[:admin][:docs] || 'https://github.com/bastosmichael/skynet'
  end

  private

  def errors_response(error_messages)
    error_messages = Array(error_messages)
    {
      error: {
        messages: error_messages.map { |message| { message: message } }
      }
    }
  end

  def json_response(status_code, json = {})
    render json: {
      response: {
        status: status_code
      }
    }.merge!(json), status: status_code
  end

  def xml_response(status_code, xml = {})
    render xml: {
      response: {
        status: status_code
      }
    }.merge!(xml), status: status_code
  end
end
