Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  resources :domains

  devise_for :users do
    get "/login" => "devise/sessions#new"
    get "/register" => "devise/registrations#new"
  end

  resources :skills do
    resources :activities
  end

  get '/activities' => 'activities#index'

  get '/new_multi' => 'skills#new_multi', as: :new_multi
  post '/new_multi' => 'skills#create_multi', as: :create_multi

  get '/set_current_domain/:id', to: 'domains#set_current', :as => 'set_domain'

  # get '/s/', to: 'skills#tag_search', :as => 'tag_search'
  # put '/admin/users/:id/activate' => 'admins#activate_user', :as => 'activate_user'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  root "skills#index"
end
