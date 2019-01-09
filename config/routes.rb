Rails.application.routes.draw do
  root 'search#show'

  controller :search do
    get :confirm, :results, :sign_up, :next_steps
  end

  resources :offenses
  resources :contacts, only: :create
end
