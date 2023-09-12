Rails.application.routes.draw do
  resources :practice_items
  resources :practice_lists
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  resources :skillsets

  # API
  namespace :api do
    namespace :v1 do
      resources :activities, only: [:index, :create]
      resources :skills, only: [:index, :create]
      resources :skillsets, only: [:index]
      post '/auth' => 'authentication#login'
    end
  end

  devise_for :users do
    get "/login" => "devise/sessions#new"
    get "/register" => "devise/registrations#new"
  end

  authenticated do
    root :to => 'skills#index', as: :authenticated
  end

  root :to => 'static_pages#home'

  resources :skills do
    resources :activities
  end

  get 'generate' => 'skills#generate', :as => 'generate_skills'


  # refresh token and get new one and redirect to dashboard
  post '/refresh_token' => 'users#refresh_token'

  get '/api_documentation' => 'static_pages#api', :as => 'api_docs'
  get '/faq' => 'static_pages#faq', :as => 'faq'

  # post '/refresh_token' => 'user#refresh_token', :as => 'refresh_token'

  get '/dashboard' => 'dashboard#index', :as => 'dashboard'

  get '/export' => 'skills#export', :as => 'export_skills'

  get '/activities' => 'activities#index'

  get '/new_multi' => 'skills#new_multi', as: :new_multi
  post '/new_multi' => 'skills#create_multi', as: :create_multi

  get '/set_current_skillset/:id', to: 'skillsets#set_current', :as => 'set_skillset'

  # get '/s/', to: 'skills#tag_search', :as => 'tag_search'
  # put '/admin/users/:id/activate' => 'admins#activate_user', :as => 'activate_user'

end
