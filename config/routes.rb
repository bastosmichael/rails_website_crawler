Rails.application.routes.draw do
  require 'sidekiq/web'
  root to: 'application#index'

  mount Sidekiq::Web, at: '/sidekiq'

  namespace :v1, defaults: { format: 'json' } do
    get '/', to: 'access#index'
    get '/best_match', to: 'record#best_match'
    get '/search', to: 'record#search'
    get '/:container/best_match', to: 'record#best_match'
    get '/:container/search', to: 'record#search'
    get '/:container/:record_id/history', to: 'record#history'
    get '/:container/:record_id/history', to: 'record#history'
    get '/:container/:record_id/:screenshot_id', to: 'record#screenshot'
    get '/:container/:record_id', to: 'record#record'
  end
end
