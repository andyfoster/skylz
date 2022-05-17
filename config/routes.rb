Rails.application.routes.draw do
  resources :domains
  devise_for :users
  resources :skills

  get '/set_current_domain/:id', to: 'domains#set_current', :as => 'set_domain'

  get '/s/', to: 'skills#tag_search', :as => 'tag_search'
  # put '/admin/users/:id/activate' => 'admins#activate_user', :as => 'activate_user'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "skills#index"
end
