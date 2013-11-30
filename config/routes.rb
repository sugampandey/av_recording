require 'sidekiq/web'
require 'sidetiq/web'

Recorder::Application.routes.draw do
  resources :cameras
  resources :captures do 
    member do 
      get :download
    end
  end  
  mount Sidekiq::Web => '/sidekiq'
  root 'captures#index'
end
