require 'sidekiq/web'
require 'sidetiq/web'

Recorder::Application.routes.draw do
  resources :cameras
  resources :captures  
  mount Sidekiq::Web => '/sidekiq'
  root 'captures#index'
end
