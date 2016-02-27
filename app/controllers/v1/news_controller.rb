class V1::NewsController < V1::AccessController
  def index
    news = Record::Base.new(params[:container], params[:record_id]).news_data(default_options)
    respond_to do |format|
      format.json { json_response(200, result: news) }
      format.xml { xml_response(200, result: news) }
    end
  end
end
