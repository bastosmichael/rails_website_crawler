class V1::Base
  attr_accessor :current_page
  attr_accessor :records

  def initialize(controller)
    @records    = V1::Records.new(self)

    @controller = controller
  end

  def request
    @controller.request
  end

  def require_auth!
    @controller.send(:require_auth!)
  end

  def json_errors(*args)
    @controller.send(:json_errors, *args)
  end

  def response(status, response = {})
    [status, response]
  end

  def current_page
    @controller.send(:current_page)
  end

  module Collection
    attr_reader :api
    # TODO: many of these delegates can goto controller
    delegate :track, :response, :json_errors, :current_page, :current_user, :current_location, :require_auth!, :require_secret!, :sign_out, :sign_in, :request, to: :api

    def build_limit(limit, default, max)
      limit = (limit.presence || default).to_i
      limit = default if limit.zero?
      limit = default if limit > max
      limit
    end

    def pagination_hash(total_pages = 0)
      pages = if total_pages < 1
                1
              else
                total_pages
      end

      next_page = (current_page + 1 if (current_page + 1) <= total_pages)

      prev_page = if (current_page - 1) > 0 && (current_page - 1) < total_pages
                    current_page - 1
                  end

      {
        next_page:    next_page,
        prev_page:    prev_page,
        total_pages:  pages,
        current_page: current_page
      }
    end

    def pagination(pagination_object)
      {
        next_page:    pagination_object.next_page,
        prev_page:    pagination_object.prev_page,
        total_pages:  pagination_object.total_pages,
        current_page: pagination_object.current_page
      }
    end
  end
end
