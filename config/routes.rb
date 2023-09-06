Rails.application.routes.draw do
  get '/search', to: 'orders#search'
  post 'customvalid', to: 'carts#customvalid'
  post 'retire', to: 'items#retire'
  resources :carts
  resources :restaurants do
    resources :orders do
      resources :items
    end
  end
  resources :restaurants do
    resources :categories do
      resources :items
    end
  end
  root to: 'restaurants#index'
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
