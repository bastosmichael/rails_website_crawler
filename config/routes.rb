Rails.application.routes.draw do
  require 'sidekiq/web'
  root to: 'application#index'
  mount Sidekiq::Web, at: '/sidekiq'

  namespace :v1, defaults: { format: 'json' } do
    get '/', to: 'access#index'
    get 'counts', to: 'access#counts'
  end
end
