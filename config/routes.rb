Todo::Application.routes.draw do

  namespace :api, defaults: {format: :json} do
    resources :users do
      resources :lists
    end
    
    resources :lists, only: [] do
      resources :items, only: [:create]
    end
    resources :items, only: [:destroy]
  end

  resources :users do
    resources :lists, except: [:index]
  end

  resources :lists, only: [] do
    resources :items, only: [:create, :new]
  end

  resources :items, only: [:destroy]

  root to: 'users#new'
end
