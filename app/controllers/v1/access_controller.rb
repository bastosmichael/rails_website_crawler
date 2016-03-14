class V1::AccessController < ApplicationController
  include CountsHelper
  before_filter :restrict_access
  before_filter :remove_params

  private

  def current_page
    params[:page].to_i > 0 ? params[:page].to_i : 1
  end

  def current_results
    params[:results].to_i > 0 ? params[:results].to_i : 10
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
    { crawl: params[:fetch],
      social: params[:social],
      fix: params[:fix],
      page: current_page,
      results: current_results }
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
