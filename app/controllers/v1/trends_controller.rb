class V1::TrendsController < V1::AccessController
  def index
    container = Record::Trends.new(params[:container])
    if params[:array].empty?
      results = errors_response('no results found')
      status = 404
    else
      results = { results: container.sort(params[:array].split(','), default_options.merge(social: params[:social] || true)).map { |h| Record::Addons.append(h) },
                  pagination: pagination(container.total) }
      status = 200
    end
    respond_to do |format|
      format.json { json_response(status, results) }
      format.xml { xml_response(status, results) }
    end
  end
end
