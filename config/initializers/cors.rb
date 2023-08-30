Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins '*' # adjust this if you want to limit origins
    resource '*',
             headers: :any,
             methods: [:get, :post, :put, :patch, :delete, :options, :head],
             expose: ['Authorization'] # expose custom headers like 'Authorization' if you're using them
  end
end
