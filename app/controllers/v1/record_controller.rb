class V1::RecordController < V1::AccessController
  def index
    object = Record::Addons.insert(record.current_data(default_options))
    respond_to do |format|
      format.json { json_response(200, result: object) }
      format.xml { xml_response(200, result: object) }
    end
  end

  def history
    history = record.historical_data(default_options)
    respond_to do |format|
      format.json { json_response(200, result: history) }
      # format.xml { xml_response(200, result: history) }
      # format.csv do
      #   # history = Record::Base.new('bestbuy-offers','9071056').historical_data
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

  def related
    related = record.related_data(default_options)
    respond_to do |format|
      format.json { json_response(200, result: related) }
      format.xml { xml_response(200, result: related) }
    end
  end

  def news
    news = record.news_data(default_options)
    respond_to do |format|
      format.json { json_response(200, result: news) }
      format.xml { xml_response(200, result: news) }
    end
  end

  def videos
    videos = record.videos_data(default_options)
    respond_to do |format|
      format.json { json_response(200, result: videos) }
      format.xml { xml_response(200, result: videos) }
    end
  end

  def links
    links = record.links_data(default_options)
    # if links[:links]
    #   links[:links] = links[:links].map {|h| Record::Addons.insert(h) }
    # end
    respond_to do |format|
      format.json { json_response(200, result: links) }
      format.xml { xml_response(200, result: links) }
    end
  end

  def references
    references = record.references_data(default_options)
    respond_to do |format|
      format.json { json_response(200, result: references) }
      format.xml { xml_response(200, result: references) }
    end
  end

  def ids
    records = Record::Base.new(params[:container]).ids(default_options)
    respond_to do |format|
      format.json { json_response(200, result: records[:result],
                                       pagination: pagination(records[:total])) }
      format.xml { xml_response(200, result: records[:result],
                                     pagination: pagination(records[:total])) }
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

  private

  def record
    @record ||= Api::V1.new(params[:container], params[:record_id])
  end
end
