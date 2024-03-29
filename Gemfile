# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.4'

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem 'rails', '~> 7.0.2', '>= 7.0.2.4'

gem 'sprockets-rails' # The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem 'pg', '~> 1.1' # Use postgresql as the database for Active Record
gem 'puma', '~> 5.0' # Use the Puma web server [https://github.com/puma/puma]
gem 'importmap-rails' # Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem 'turbo-rails' # Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem 'stimulus-rails' # Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem 'tailwindcss-rails' # Use Tailwind CSS [https://github.com/rails/tailwindcss-rails]

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem 'jbuilder'

# Use Redis adapter to run Action Cable in production
# gem "redis", "~> 4.0"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

gem 'devise_token_auth' # For API authentication

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

# Use Sass to process CSS
# gem "sassc-rails"

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem 'image_processing', '~> 1.2'

gem 'devise' # Use Devise for authentication
gem 'sassc-rails' # RailsAdmin 3 wants this

gem "chartkick" # For graphs and charts
gem 'groupdate' # Required for group_by_day, group_by_week, etc.

gem 'redcarpet' # For markdown rendering
gem 'rack-cors' # for cross-origin resource sharing (react api etc)
gem "ruby-openai" # For OpenAI API
gem 'httparty' # For web requests

# Use the font-awesome icons
gem 'font-awesome-rails'
gem 'rails_admin', '~> 3.0' # RailsAdmin for managing data

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: %i[mri mingw x64_mingw]
  gem 'pry-rails'
  gem 'rspec-rails', '~> 6.0.0'
end

group :development do
  gem 'web-console'   # Use console on exceptions pages [https://github.com/rails/web-console]
  gem 'erb-formatter' # For better ERB formatting
  gem 'bullet'  # help to kill N+1 queries and unused eager loading

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'webdrivers'
end
