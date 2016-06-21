class V1::ApplicationController < ActionController::Base
  # ENABLE_ANALYTICS = true

  # skip_before_action :verify_authenticity_token
  before_action :require_auth!
  before_action :throttle
  before_action :init_api

  class AuthenticationError < Exception; end

  class PermissionError < Exception; end

  class RatelimitError < Exception; end

  rescue_from StandardError do |_exception|
    # Honeybadger.context(tags: 'api')
    # Honeybadger.notify(exception)
    json_response(500, json_errors('☃ Looks like something went wrong!'))
  end unless Rails.env.development? || Rails.env.test?

  rescue_from AuthenticationError, with: :authentication_error

  rescue_from PermissionError, with: :permission_error

  rescue_from RatelimitError, with: :ratelimit_error

  private

  def throttle
    if limit > 0
      redis_id = check_token || request.ip
      count = redis.incr redis_id
      redis.expire(redis_id, 1.day) if count == 1

      raise RatelimitError unless count <= limit.to_i
    else
      true
    end
  else

  end

  def limit
    @limit ||= Rails.configuration.config['api_keys'][check_token]['limit'].to_i
  end

  def redis
    Redis.new(url: Rails.configuration.config['redis'], db:2)
  end

  def authentication_error
    json_response(401, json_errors('Authentication required'))
  end

  def permission_error
    json_response(403, json_errors('Endpoint Permission required'))
  end

  def ratelimit_error
    json_response(403, json_errors('You have fired too many requests. Please wait for some time.'))
  end

  def require_auth!
    if check_token
      true
    elsif token_exists?
      raise AuthenticationError
    else
      @limit = 20
      true
    end
  end

  def token_exists?
    @token_exists ||= if params[:access_token].presence
                        true
                      else
                        authenticate_or_request_with_http_token do |token|
                          if token.presence
                            true
                          else
                            false
                          end
                        end
                      end
  end

  def check_token
    @check_token ||= if Rails.configuration.config['api_keys'].keys.include?(params[:access_token])
                        params[:access_token].presence
                      else
                        authenticate_or_request_with_http_token do |token|
                          if Rails.configuration.config['api_keys'].keys.include?(token)
                            token
                          end
                        end
                      end
  end

  def check_permissions end_point
    raise PermissionError unless Rails.configuration.config['api_keys'][check_token]['permissions'] && Rails.configuration.config['api_v2'][check_token]['permissions'].include?(end_point.to_s)
  end

  def current_page
    params[:page].to_i > 0 ? params[:page].to_i : 1
  end

  def init_api
    @api = Api::V1::Base.new(self)
  end

  def require_ssl
    if Rails.env.production? && !request.ssl?
      render json: json_response_object(400, json_errors('SSL is required'))
      return false
    end
  end

  # Public: Generate a standard JSON error reseponse.
  #
  # error_messages  - The String or Array of error messages.
  #
  # Returns Hash.
  def json_errors(error_messages)
    error_messages = Array(error_messages)
    {
      error: {
        errors: error_messages.map { |message| { message: message } }
      }
    }
  end

  # Public: Generate a standard JSON response wrapper.
  #
  # status_code  - The Integer HTTP status code.
  # json         - The Hash JSON payload.
  #
  # Returns Hash.
  def json_response(status_code, json = {})
    render json: json_response_object(status_code, json), status: 200
  end

  def json_response_object(status_code, json = {})
    {
      response: {
        status: status_code
      }
    }.merge!(json)
  end
end
