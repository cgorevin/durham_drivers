Rails.application.routes.draw do
  get '/', constraints: { subdomain: 'www' }, to: redirect('/', subdomain: nil) # no subdomain
  scope "(:locale)", :locale => /en|es/ do
    root 'search#show'

    controller :search do
      get :results, :sign_up, :next_steps
      post :confirm, :results
      get :confirm, to: redirect('/')
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

  resources :relief_messages, only: :show
  get 'm/:token' => 'relief_messages#show', as: :token
  # get '', to: redirect("/#{I18n.default_locale}/")
end
