class V1::VideosController < V1::AccessController
  def index
    videos = Record::Base.new(params[:container], params[:record_id]).videos_data(default_options)
    respond_to do |format|
      format.json { json_response(200, results: videos) }
      format.xml { xml_response(200, results: videos) }
    end
  end
end
