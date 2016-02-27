class V1::NewsController < V1::AccessController
  def index
    news = Record::Base.new(params[:container], params[:record_id]).news_data(default_options)
    respond_to do |format|
      format.json { json_response(200, results: news) }
      format.xml { xml_response(200, results: news) }
    end
  end
end
