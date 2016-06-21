class ApplicationController < ActionController::Base
  respond_to :json

  def index
    redirect_to Rails.configuration.config[:admin][:docs] || 'https://github.com/bastosmichael/skynet'
  end
end
