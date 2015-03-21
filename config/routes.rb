Todo::Application.routes.draw do
  namespace :api do
    root 'lists#index'

    resources :users, except: [:new, :edit] do
      resources :lists, except: [:new, :edit]
    end

    resources :lists, only: [] do
      resources :items, only: :create
    end

    resources :items, only: :destroy
  end
end
