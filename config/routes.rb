Todo::Application.routes.draw do
  namespace :api do
    post 'signup', to: 'users#create', as: 'signup'

    resources :users, except: [:new, :edit] do
      resources :lists, except: [:new, :edit]
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
