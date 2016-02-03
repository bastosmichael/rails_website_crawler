class V1::ScreenshotController < V1::AccessController
  def index
    screenshot = Record::Screenshot.new(params[:container], params[:record_id], params[:screenshot_id])
    respond_to do |format|
      format.json { json_response(200, screenshot.data) }
      format.xml { xml_response(200, screenshot.data) }
      format.jpg { redirect_to screenshot.link }
    end
  end
end
