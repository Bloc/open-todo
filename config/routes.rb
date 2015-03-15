Todo::Application.routes.draw do
  namespace :api do
    post 'signup', to: 'users#create', as: 'signup'
    post 'login', to: 'sessions#create', as: 'login'
    delete 'logout', to: 'sessions#destroy', as: 'logout'

    resources :users, only: :index do
      resources :lists, except: :index
    end

    resources :lists, only: [] do
      resources :items, only: :create
    end

    resources :items, only: :destroy
  end

  resources :users do
    resources :lists, except: :index
  end

  resources :lists, only: [] do
    resources :items, only: [:create, :new]
  end

  resources :items, only: :destroy
end
