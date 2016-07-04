class V1::BatchController < V1::AccessController
  def index
    container = Api::V1.new(params[:container])
    new_params = params
    new_params.delete(:container) if params[:container]
    if new_params.empty?
      results = errors_response('no results found')
      status = 404
    else
      results = { results: container.batch(new_params[:batch], default_options.merge(results: current_results)).map { |h| Record::Addons.insert(Record::Addons.append(h)) } }
      status = 200
    end
    respond_to do |format|
      format.json { json_response(status, results) }
      format.xml { xml_response(status, results) }
    end
  end
end
