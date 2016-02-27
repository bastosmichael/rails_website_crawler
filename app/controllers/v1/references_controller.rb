class V1::ReferencesController < V1::AccessController
  def index
    references = Record::Base.new(params[:container], params[:record_id]).references_data(default_options)
    respond_to do |format|
      format.json { json_response(200, results: references) }
      format.xml { xml_response(200, results: references) }
    end
  end
end
