Rails.application.routes.draw do
  get "users/index"
  get "orders/index"
  get "orders/show"
  get "orders/create"
  get "carts/show"
  get "carts/add"
  get "carts/remove"
  root 'products#index'

  devise_for :users

  resources :categories
  resources :products
  resources :users, only: [:index]

  resource :cart, only: [:show] do
    post 'add/:product_id', to: 'carts#add', as: :add_to
    delete 'remove/:product_id', to: 'carts#remove', as: :remove_from
  end

  resources :orders, only: [:index, :show, :create] do
    member do
      patch :update_status
    end
  end

  get 'dashboard', to: 'dashboards#show'
  get "orders/:id/receipt", to: "orders#receipt", as: "receipt_order"


end
