Rails.application.routes.draw do
  require 'sidekiq/web'
  root to: 'application#index'
  get 'counts', to: 'application#counts'

  mount Sidekiq::Web, at: '/sidekiq'

  namespace :v1, defaults: { format: 'json' } do
    get '/', to: 'access#index'
    get '/:container/:record_id/:screenshot_id', to: 'record#screenshot'
    get '/:container/:record_id', to: 'record#record'
  end
end
