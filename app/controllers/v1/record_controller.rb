class V1::RecordController < V1::AccessController
  def record
    record = Record::Base.new(params[:container], params[:record_id] + '.json').current_data
    respond_to do |format|
      format.json { render :json => record.to_json }
      format.xml { render :xml => record.to_xml }
    end
  end

  def history
    history = Record::Base.new(params[:container], params[:record_id] + '.json').historical_data
    respond_to do |format|
      format.json { render :json => history.to_json }
      format.xml { render :xml => history.to_xml }
      # format.csv do
      #   csv_string = history.first.collect { |k, _v| k }.join(',') + "\n" + history.collect { |node| "#{node.collect { |_k, v| v }.join(',')}\n" }.join
      #   send_data csv_string, type: 'text/csv; charset=iso-8859-1; header=present', disposition: 'attachment;data=historical_data.csv'
      # end
    end
  end

  def screenshot
    screenshot = Record::Screenshot.new(params[:container], params[:record_id], params[:screenshot_id])
    respond_to do |format|
      format.json { render :json => screenshot.data.to_json }
      format.xml { render :xml => screenshot.data.to_xml }
      format.jpg { redirect_to screenshot.link }
    end
  end
end
