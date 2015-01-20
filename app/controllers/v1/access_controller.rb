class V1::AccessController < ApplicationController

  private

  def track_usage
    if api_json['last_used'] == Date.today.to_s
      api_json['api_daily_usage'] = api_json['api_daily_usage'] + 1
    else
      api_json['last_used'] = Date.today.to_s
      api_json['api_daily_usage'] = 0
    end
    api_record.data = api_json
  end

  def check_partner(access_token)
    @api_key = access_token
    if api_json['active'] == true && api_usage_cap.nil?
      return true
    elsif api_json['active'] == true && api_daily_usage < api_usage_cap
      track_usage
      return true
    end
  rescue
    return false
  end

  def api_usage_cap
    api_json['api_usage_cap']
  end

  def api_daily_usage
    api_json['api_daily_usage']
  end
end
