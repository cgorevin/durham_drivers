Rails.application.routes.draw do
  root 'offenses#index'
  resources :offenses
  resources :contacts, only: :create
end
