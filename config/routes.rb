Rails.application.routes.draw do
  root 'items#index'

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }

  resources :users, only: [:show, :edit, :update]
  resources :items, only: [:index, :show]

  resources :carts, only: [:show, :create, :edit, :update, :destroy] do
    delete 'remove_item/:item_id', to: 'carts#remove_item', as: 'remove_item'
    post 'add_item/:item_id', to: 'carts#add_item', as: 'add_item'
    post 'confirm_order', to: 'carts#confirm_order', as: 'confirm_order'
    post 'checkout', to: 'carts#checkout', as: 'checkout'
  end

  resources :orders, only: [:new, :create, :show] do
    member do
      get 'success'
      get 'cancel'
    end
  end

  resources :charges, only: [:create]
  resources :payments, only: [:new, :create]

  get "up" => "rails/health#show", as: :rails_health_check

  post '/webhooks/stripe', to: 'webhooks#stripe'
end
