class V1::LinksController < V1::AccessController
  def index
    links = Record::Base.new(params[:container], params[:record_id]).links_data(default_options)
    respond_to do |format|
      format.json { json_response(200, results: links) }
      format.xml { xml_response(200, results: links) }
    end
  end
end
