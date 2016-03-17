Rails.application.routes.draw do

  root to: 'application#index'

  require "sidekiq/web"
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    username == Rails.configuration.config[:admin][:username] && password == Rails.configuration.config[:admin][:password]
  end if Rails.env.production?
  mount Sidekiq::Web, at: "/sidekiq"

  namespace :v1, defaults: { format: 'json' } do
    get '/', to: 'status#index'
    get '/match', to: 'match#index', results: 10
    get '/search/:query', to: 'search#index'
    post '/batch' => 'batch#index'
    get '/trends/:array', to: 'trends#index'
    get '/:container/ids', to: 'record#ids'
    get '/:container/match', to: 'match#index'
    get '/:container/search/:query', to: 'search#index'
    get '/:container/trends/:array', to: 'trends#index'
    get '/:container/:record_id/history', to: 'history#index'
    get '/:container/:record_id/news', to: 'news#index'
    get '/:container/:record_id/videos', to: 'videos#index'
    get '/:container/:record_id/references', to: 'references#index'
    get '/:container/:record_id/links', to: 'links#index'
    get '/:container/:record_id/:screenshot_id', to: 'screenshot#index'
    get '/:container/:record_id', to: 'record#index'
  end
end
