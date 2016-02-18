class V1::SearchController < V1::AccessController
  def index
    container = Record::Search.new(params[:container])
    new_params = params
    new_params.delete(:container) if params[:container]
    if new_params.empty?
      results = errors_response('no results found')
      status = 404
    else
      results = { results: container.search(new_params, default_options.merge(results: params[:results].try(:to_i) || 10)).map { |h| Record::Addons.insert h },
                  pagination: pagination(container.total) }
      status = 200
    end
    respond_to do |format|
      format.json { json_response(status, results) }
      format.xml { xml_response(status, results) }
    end
  end
end
