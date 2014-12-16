Rails.application.routes.draw do
  require 'sidekiq/web'
  root to: 'application#index'
  mount Sidekiq::Web, at: '/sidekiq'

  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      get '/', to: 'application#index'
    end
  end

  namespace :v1, defaults: { format: 'json' } do
    get '/', to: 'application#index'
  end
end
