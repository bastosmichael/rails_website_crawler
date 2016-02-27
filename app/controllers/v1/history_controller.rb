class V1::HistoryController < V1::AccessController
  def index
    history = Record::Base.new(params[:container], params[:record_id]).historical_data(default_options)
    respond_to do |format|
      format.json { json_response(200, history: history) }
      # format.xml { xml_response(200, history) }
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
end
