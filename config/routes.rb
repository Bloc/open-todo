Todo::Application.routes.draw do
  resources :users do
    resources :lists, except: [:index]
  end

  resources :lists, only: [] do
    resources :items, only: [:create, :new]
  end

  resources :items, only: [:destroy]

  namespace :api do
    resources :users, only: [:create, :index]
  end

  root to: 'users#new'
end
