Todo::Application.routes.draw do

  namespace :api do

      resources :users

      resources :lists do
        resources :items, only: [:create, :update, :destroy]
      end
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
