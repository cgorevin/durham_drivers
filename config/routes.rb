Rails.application.routes.draw do
  devise_for :admins
  get 'search_histories/index'
  root 'search#show'

  controller :search do
    get :results, :sign_up, :next_steps
    post :confirm, :results
  end

  resources :offenses do
    collection do
      get 'group/:group' => 'offenses#group', as: :group
      post 'group/:group' => 'offenses#group_update'
    end
  end
  resources :contacts, only: :create
  get '/panel' => 'offenses#panel'
end
