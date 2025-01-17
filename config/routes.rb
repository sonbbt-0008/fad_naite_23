Rails.application.routes.draw do
  root "static_pages#home"

  get "/help", to: "static_pages#help"
  get "/about", to: "static_pages#about"
  get "/contact", to: "static_pages#contact"

  get "/signup", to: "users#new"
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  get "/cart", to: "carts#show"
  post "/remove_item", to: "carts#remove_item"
  post "/update_item", to: "carts#update_item"
  delete "/cart", to: "carts#destroy"

  resources :ratings, only: :create
  resources :users, except: %i(index destroy)
  resources :products, only: %i(index show)
  resources :orders
  resources :order_lists, only: %i(update destroy)

  namespace :admin do
    resources :users, only: %i(index destroy)
    resources :products
  end
end
