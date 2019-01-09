Rails.application.routes.draw do
  root 'offenses#index'
  resources :offenses
  post 'contacts/create'
end
