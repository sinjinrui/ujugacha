Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root "lotteries#index"
  resources :lotteries, only: [:new, :index, :create, :edit, :destroy, :update]
  resources :results, only: [:new, :create, :destroy]
  resources :listeners, only: [:index, :create, :destroy]
end
