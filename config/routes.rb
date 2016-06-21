Rails.application.routes.draw do

  root to: 'application#index'

  require "sidekiq/web"
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    username == Rails.configuration.config[:admin][:username] && password == Rails.configuration.config[:admin][:password]
  end if Rails.env.production?
  mount Sidekiq::Web, at: "/sidekiq"

  namespace :v1, defaults: { format: 'json' } do
    get '/:site-:type/:id', to: 'records#show'
    get '/:type/:site/:id', to: 'records#show'
    # get '/', to: 'status#index'
    # get '/match', to: 'match#index', results: 10
    # get '/search/:query', to: 'search#index'
    # post '/batch' => 'batch#index'
    # get '/trends/:array', to: 'trends#index'
    # get '/:container/ids', to: 'record#ids'
    # get '/:container/match', to: 'match#index'
    # get '/:container/search/:query', to: 'search#index'
    # get '/:container/trends/:array', to: 'trends#index'
    # get '/:container/:record_id/related', to: 'record#related'
    # get '/:container/:record_id/history', to: 'record#history'
    # get '/:container/:record_id/news', to: 'record#news'
    # get '/:container/:record_id/videos', to: 'record#videos'
    # get '/:container/:record_id/references', to: 'record#references'
    # get '/:container/:record_id/links', to: 'record#links'
    # get '/:container/:record_id/:screenshot_id', to: 'record#screenshot'
    # get '/:container/:record_id', to: 'record#index'
  end
end
