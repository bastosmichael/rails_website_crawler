class V1::LinksController < V1::AccessController
  def index
    links = Record::Base.new(params[:container], params[:record_id]).links_data(default_options)
    if links[:links]
      links[:links] = links[:links].map {|h| Record::Addons.insert(h) }
    end
    respond_to do |format|
      format.json { json_response(200, result: links) }
      format.xml { xml_response(200, result: links) }
    end
  end
end
