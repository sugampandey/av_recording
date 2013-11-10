require 'sidekiq/web'
require 'sidetiq/web'

Recorder::Application.routes.draw do
  resources :cameras
  resources :captures

  get "/delayed_job" => DelayedJobWeb, :anchor => false
  
  mount Sidekiq::Web => '/sidekiq'
  root 'captures#index'
end
