Rails.application.routes.draw do
  resources :practice_items
  resources :practice_lists
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  resources :domains

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

  get '/export' => 'skills#export' , :as => 'export_skills'

  get '/activities' => 'activities#index'

  get '/new_multi' => 'skills#new_multi', as: :new_multi
  post '/new_multi' => 'skills#create_multi', as: :create_multi

  get '/set_current_domain/:id', to: 'domains#set_current', :as => 'set_domain'

  # get '/s/', to: 'skills#tag_search', :as => 'tag_search'
  # put '/admin/users/:id/activate' => 'admins#activate_user', :as => 'activate_user'

end
