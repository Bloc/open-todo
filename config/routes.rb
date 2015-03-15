Todo::Application.routes.draw do
  namespace :api, defaults: { format: :json }, constraints: { subdomain: 'api' }, path: '/' do
    resources :users, only: [:index, :create] do
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
