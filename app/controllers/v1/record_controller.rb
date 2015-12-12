class V1::RecordController < V1::AccessController
  def record
    record = Record::Addons.insert(Record::Base.new(params[:container], params[:record_id] + '.json').current_data(default_options).merge(container: params[:container]))
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
      #   # history = Record::Base.new('bestbuy-offers','9071056.json').historical_data
      #   headers_hash = history.keys.map {|k| {k => nil}}.inject({},:merge)
      #   dates_hash = history.values.flat_map {|hash| if hash.try(:keys) then hash.keys end }.compact.uniq.sort.map {|date| {date.to_date => headers_hash} }.inject({},:merge)
      #   dates_hash.each do |key,value|
      #     puts key
      #     value.each do |k,v|
      #       ap k
      #       ap v
      #       puts history[k][key.to_date]
      #     #   # dates_hash[key][k] = history[k][key]
      #     end
      #   end
      #   dates_hash

      #   # history.each do |key,value|
      #   #   if value.is_a? Hash
      #   #     ap key
      #   #     value.each do |k,v|
      #   #       ap k.to_date
      #   #       ap v
      #   #       dates_hash[k][key] = v
      #   #     end
      #   #   else
      #   #     # dates_hash.keys.each do |date|
      #   #     #   dates_hash[date][key] = value
      #   #     # end
      #   #   end
      #   # end

      #   # dates =
      #   # csv_string = history.keys.join(',') + "\n" + history.collect { |node| "#{node.collect { |_k, v| v }.join(',')}\n" }.join
      #   # send_data csv_string, type: 'text/csv; charset=iso-8859-1; header=present', disposition: 'attachment;data=historical_data.csv'
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
      results = {results: container.best(new_params, default_options.merge(results: params[:results] || 1)).map {|h| Record::Addons.insert h } }
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
      results = {results: container.search(new_params, default_options.merge(results: params[:results] || 12)).map {|h| Record::Addons.insert h } }
      status = 200
    end
    respond_to do |format|
      format.json { json_response(status, results) }
      format.xml { xml_response(status, results) }
    end
  end

  def top
    container = Record::Top.new(params[:container])
    if params[:array].empty?
      results = errors_response('no results found')
      status = 404
    else
      results = {results: container.sort(params[:array].split(','), default_options.merge(social: params[:social] || true)).map {|h| Record::Addons.insert h } }
      status = 200
    end
    respond_to do |format|
      format.json { json_response(status, results) }
      format.xml { xml_response(status, results) }
    end
  end

  private

  def default_options
    { crawl: params[:fetch] || true, social: params[:social] || false, fix: params[:fix] || false }
  end
end
