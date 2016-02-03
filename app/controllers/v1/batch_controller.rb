class V1::BatchController < V1::AccessController
  def index
    # record = Record::Addons.insert(Record::Base.new(params[:container], params[:record_id] + '.json').current_data(default_options).merge(container: params[:container]))
    # respond_to do |format|
    #   format.json { json_response(200, record) }
    #   format.xml { xml_response(200, record) }
    # end
  end
end
