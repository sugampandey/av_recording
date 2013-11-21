require 'sidekiq/web'
require 'sidetiq/web'

Recorder::Application.routes.draw do
  resources :schedules
  resources :cameras
  resources :captures  
  mount Sidekiq::Web => '/sidekiq'
  root 'captures#index'
end
