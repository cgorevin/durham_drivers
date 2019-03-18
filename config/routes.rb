Rails.application.routes.draw do
  # redirect all www requests to no subdomain site
  get '/', constraints: { subdomain: 'www' }, to: redirect('/', subdomain: nil)
  # redirect all com requests to org site
  get '/', constraints: { host: /g.com/ }, to: redirect('https://secondchancedriving.org')

  get '/admin', to: redirect('/admins/sign_in')

  # user related paths
  scope "(:locale)", :locale => /en|es/ do
    root 'search#show'
    controller :search do
      get :results, :next_steps, :sign_up
      post :confirm, :results
      get :confirm, to: redirect('/')
    end
  end

  # admin related paths
  devise_for :admins
  get '/panel' => 'offenses#panel'
  get '/stats' => 'offenses#stats'
  get 'search_histories/index'
  resources :contacts, only: [:index, :show, :create, :update]
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
