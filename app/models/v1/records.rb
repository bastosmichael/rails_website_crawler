class V1::Records
  include V1::Base::Collection

  def initialize(api)
    @api = api
  end

  def show(params = {})
    id = params[:id].presence
    type = params[:type].presence
    site = params[:site].presence

    if id.nil? || type.nil? || site.nil?
      return response(400, json_errors('Parameter `type`, `site` and `id` is required'))
    end

    response(200, result: nil)
  end
end
