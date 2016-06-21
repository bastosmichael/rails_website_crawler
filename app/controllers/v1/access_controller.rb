class V1::AccessController < ApplicationController
  include CountsHelper
  before_action :require_auth!
  before_action :throttle
  before_filter :remove_params

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
  rescue
    true
  else

  end

  def limit
    @limit ||= Rails.configuration.config[:admin][:api_keys][check_token.try(:to_sym)][:limit].to_i
  end

  def redis
    Redis.new(url: Rails.configuration.config[:redis], db:2)
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
    @check_token ||= if Rails.configuration.config[:admin][:api_keys].keys.include?(params[:access_token].try(:to_sym))
                        params[:access_token].presence
                      else
                        authenticate_or_request_with_http_token do |token|
                          if Rails.configuration.config[:admin][:api_keys].keys.include?(token.try(:to_sym))
                            token
                          end
                        end
                      end
  end

  def check_permissions end_point
    raise PermissionError unless Rails.configuration.config[:admin][:api_keys][check_token.try(:to_sym)][:permissions] && Rails.configuration.config[:admin][:api_keys][check_token.try(:to_sym)][:permissions].include?(end_point.to_s)
  end

  def current_page
    params[:page].to_i > 0 ? params[:page].to_i : 1
  end

  def current_results
    params[:results].to_i > 0 ? params[:results].to_i : 10
  end

  def default_true value
    value == 'false' ? false : true
  end

  def default_false value
    value == 'true' ? true : false
  end

  def pagination(total_pages = 0)
    pages = if total_pages < 1
              1
            else
              total_pages
            end

    next_page = (current_page + 1 if (current_page + 1) <= total_pages)

    prev_page = if (current_page - 1) > 0 && (current_page - 1) < total_pages
                  current_page - 1
                end

    {
      next_page:    next_page,
      prev_page:    prev_page,
      total_pages:  pages,
      current_page: current_page
    }
    end

  def default_options
    { crawl: default_true(params[:fetch]),
      social: default_false(params[:social]),
      fix: default_false(params[:fix]),
      page: current_page,
      results: current_results }
  end

  def remove_params
    params.delete(:action)
    params.delete(:controller)
    params.delete(:format)
    params.delete(:access_token) if params[:access_token]
  end

  def json_errors(error_messages)
    error_messages = Array(error_messages)
    {
      error: {
        errors: error_messages.map { |message| { message: message } }
      }
    }
  end

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
