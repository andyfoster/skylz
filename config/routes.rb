Rails.application.routes.draw do
  resources :domains
  devise_for :users
  resources :skills
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "skills#index"
end
