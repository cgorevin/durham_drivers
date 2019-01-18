Rails.application.routes.draw do
  devise_for :admins
  get 'search_histories/index'
  root 'search#show'

  controller :search do
    get :results, :sign_up, :next_steps
    post :confirm
  end

  resources :offenses
  resources :contacts, only: :create
  get '/panel' => 'offenses#panel'
end
