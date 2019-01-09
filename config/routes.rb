Rails.application.routes.draw do
  root 'offenses#index'
  resources :offenses
end
