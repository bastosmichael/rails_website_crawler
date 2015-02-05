class V1::RecordController < V1::AccessController

  def record
    render json: Record::Base.new(params[:container], params[:record_id] + '.json').current_data.to_json
  end

  def history
    render json: Record::Base.new(params[:container], params[:record_id] + '.json').historical_data.to_json
  end

  def screenshot
    render json: params.to_json
  end

end
