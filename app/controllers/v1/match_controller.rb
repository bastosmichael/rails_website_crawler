class V1::MatchController < V1::AccessController
  def index
    container = Record::Match.new(params[:container])
    new_params = params
    new_params.delete(:container) if params[:container]
    if new_params.empty?
      results = errors_response('no results found')
      status = 404
    else
      results = { results: container.best(new_params, default_options.merge(results: current_results)).map { |h| Record::Addons.append(h) },
                  pagination: pagination(container.total) }
      status = 200
    end
    respond_to do |format|
      format.json { json_response(status, results) }
      format.xml { xml_response(status, results) }
    end
  end
end
