class V1::RecordController < V1::AccessController
  def index
    record = Record::Addons.insert(Record::Base.new(params[:container], params[:record_id]).current_data(default_options))
    respond_to do |format|
      format.json { json_response(200, result: record) }
      format.xml { xml_response(200, result: record) }
    end
  end

  def ids
    record = Record::Base.new(params[:container]).ids(default_options)
    respond_to do |format|
      format.json { json_response(200, result: record[:result],
                                       pagination: pagination(record[:total])) }
      format.xml { xml_response(200, result: record[:result],
                                     pagination: pagination(record[:total])) }
    end
  end
end
