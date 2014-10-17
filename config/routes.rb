Todo::Application.routes.draw do

  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      resources :users, except: [:destroy, :new] do 
        resources :lists, only: [:index]
      end

      resources :lists, only: [:index, :show, :create, :update, :destroy] do
        resources :items, only: [:create, :update]
      end

      resources :items, only: [:destroy]
    end
  end

  resources :users do 
    resources :lists, except: [:index]
  end

  resources :lists do
    resources :items, only: [:create, :new]
  end

  resources :items, only: [:destroy]

  root to: 'users#new'
end
