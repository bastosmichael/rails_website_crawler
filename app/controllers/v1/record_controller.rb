class V1::RecordController < V1::AccessController

  def record
    data = Record::Base.new(params[:container], params[:record_id] + '.json').data
    render json: data.to_json
  end

  def screenshot
    render json: params.to_json
  end

end
