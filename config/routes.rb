Rails.application.routes.draw do
  resources :videos
  resources :coupons
  post 'subscriptions/expire', to: 'subscriptions#expire'
  get 'products/:id', to: 'products#show', :as => :products
  devise_for :users, :controllers => { :registrations => 'registrations' }
  resources :users
  mount StripeEvent::Engine, at: '/stripe'
  root :to => 'visitors#index'
end
