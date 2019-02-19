Rails.application.routes.draw do
  scope "(:locale)", :locale => /en|es/ do
    root 'search#show'

    controller :search do
      get :results, :sign_up, :next_steps
      post :confirm, :results
    end
  end

  devise_for :admins
  get '/panel' => 'offenses#panel'
  get 'search_histories/index'
  resources :contacts, only: :create
  resources :offenses do
    collection do
      get 'group/:group' => 'offenses#group', as: :group
      post 'group/:group' => 'offenses#group_update'
    end
  end
end
