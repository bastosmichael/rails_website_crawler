Rails.application.routes.draw do
  require 'sidekiq/web'
  root to: 'application#index'

  mount Sidekiq::Web, at: '/sidekiq'

  namespace :v1, defaults: { format: 'json' } do
    get '/', to: 'access#index'
    get '/mapping', to: 'counts#mapping'
    get '/processing', to: 'counts#processing'
    get '/pending', to: 'counts#pending'
    get '/:container/count', to: 'counts#count'
    get '/:container/:record_id/:screenshot_id', to: 'record#screenshot'
    get '/:container/:record_id', to: 'record#record'
  end
end
