class V1::RecordController < V1::AccessController
  def record
    record = Record::Base.new(params[:container], params[:record_id] + '.json').current_data
    respond_to do |format|
      format.json { json_response(record) }
      format.xml { xml_response(record) }
    end
  end

  def history
    history = Record::Base.new(params[:container], params[:record_id] + '.json').historical_data
    respond_to do |format|
      format.json { json_response(history) }
      format.xml { xml_response(history) }
      # format.csv do
      #   csv_string = history.first.collect { |k, _v| k }.join(',') + "\n" + history.collect { |node| "#{node.collect { |_k, v| v }.join(',')}\n" }.join
      #   send_data csv_string, type: 'text/csv; charset=iso-8859-1; header=present', disposition: 'attachment;data=historical_data.csv'
      # end
    end
  end

  def screenshot
    screenshot = Record::Screenshot.new(params[:container], params[:record_id], params[:screenshot_id])
    respond_to do |format|
      format.json { json_response(screenshot.data) }
      format.xml { xml_response(screenshot.data) }
      format.jpg { redirect_to screenshot.link }
    end
  end

  def best_match
    container = Record::Match.new(params[:container])
    new_params = params
    new_params.delete(:container) if params[:container]
    if new_params.empty?
      results = { error: 'no results found' }
    else
      results = container.best(new_params, {crawl: params[:crawl] || true})
    end
    respond_to do |format|
      format.json { json_response(results) }
      format.xml { xml_response(results) }
    end
  end

  def search
    container = Record::Search.new(params[:container])
    new_params = params
    new_params.delete(:container) if params[:container]
    if new_params.empty?
      results = { error: 'no results found' }
    else
      results = container.search(new_params, {crawl: params[:crawl] || true, social: true})
    end
    respond_to do |format|
      format.json { json_response(results) }
      format.xml { xml_response(results) }
    end
  end
end
