Rails.application.routes.draw do
  devise_for :admins
  get 'search_histories/index'
  root 'search#show'

  controller :search do
    get :sign_up, :next_steps
    post :confirm, :results
  end

  resources :offenses do
    collection do
      get 'group/:group' => 'offenses#group', as: :group
    end
  end
  resources :contacts, only: :create
end
