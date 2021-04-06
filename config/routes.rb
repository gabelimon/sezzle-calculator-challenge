Rails.application.routes.draw do
  devise_for :users
  get 'calculator/index'
  post 'calculator/calculate'

  root 'calculator#index'
  resources :sessions, only: [:create]
end
