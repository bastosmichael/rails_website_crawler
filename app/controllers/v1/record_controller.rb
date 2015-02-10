class V1::RecordController < V1::AccessController

  def record
    render json: Record::Base.new(params[:container], params[:record_id] + '.json').current_data.to_json
  end

  def history
    render json: Record::Base.new(params[:container], params[:record_id] + '.json').historical_data.to_json
  end

  def screenshot
    if match = params[:container].match(/(.+?)-/)
      params[:container] = match[1] + '-screenshots'
    end
    if screenshot = Cloud.new(params[:container]).get(params[:record_id] + '/' + params[:screenshot_id] + '.jpg')
      render json: {id: params[:record_id], screenshot_url: screenshot.url(Date.tomorrow.to_time.to_i)}.to_json
    else
      render json: {error: 'screenshot not available'}.to_json
    end
  end

end
