Todo::Application.routes.draw do
  get "sign_up" => "users#new", :as => "sign_up"
  resources :users do
    resources :lists, except: [:index]
  end

  resources :lists do
    resources :items, only: [:create, :new]
  end

  resources :items, only: [:destroy]

  namespace :api, :defaults => { :format => :json } do
    resources :users do
      resources :lists, except: [:index]
    end

    resources :lists, only: [:index] do
      resources :items, only: [:create, :new]
    end

    resources :items, only: [:destroy]
  end

  root to: 'users#new'
end
