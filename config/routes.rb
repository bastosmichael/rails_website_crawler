Rails.application.routes.draw do
  require 'sidekiq/web'
  root to: redirect('/sidekiq')
  mount Sidekiq::Web, at: '/sidekiq'
end
