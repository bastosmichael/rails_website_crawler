class V1::RecordController < V1::AccessController
  def record
    record = Record::Base.new(params[:container], params[:record_id] + '.json').current_data default_options
    respond_to do |format|
      format.json { json_response(200, record) }
      format.xml { xml_response(200, record) }
    end
  end

  def history
    history = Record::Base.new(params[:container], params[:record_id] + '.json').historical_data default_options
    respond_to do |format|
      format.json { json_response(200, history) }
      # format.xml { xml_response(200, history) }
      # format.csv do
      #   csv_string = history.first.collect { |k, _v| k }.join(',') + "\n" + history.collect { |node| "#{node.collect { |_k, v| v }.join(',')}\n" }.join
      #   send_data csv_string, type: 'text/csv; charset=iso-8859-1; header=present', disposition: 'attachment;data=historical_data.csv'
      # end
    end
  end

  def screenshot
    screenshot = Record::Screenshot.new(params[:container], params[:record_id], params[:screenshot_id])
    respond_to do |format|
      format.json { json_response(200, screenshot.data) }
      format.xml { xml_response(200, screenshot.data) }
      format.jpg { redirect_to screenshot.link }
    end
  end

  def best_match
    container = Record::Match.new(params[:container])
    new_params = params
    new_params.delete(:container) if params[:container]
    if new_params.empty?
      results = errors_response('no results found')
      status = 404
    else
      results = container.best(new_params, default_options.merge(results: params[:results] || 1))
      status = 200
    end
    respond_to do |format|
      format.json { json_response(status, results) }
      format.xml { xml_response(status, results) }
    end
  end

  def search
    container = Record::Search.new(params[:container])
    new_params = params
    new_params.delete(:container) if params[:container]
    if new_params.empty?
      results = errors_response('no results found')
      status = 404
    else
      results = container.search(new_params, default_options.merge(results: params[:results] || 10))
      status = 200
    end
    respond_to do |format|
      format.json { json_response(status, results) }
      format.xml { xml_response(status, results) }
    end
  end

  private

  def default_options
    { crawl: params[:fetch] || true, social: params[:social] || false }
  end
end
