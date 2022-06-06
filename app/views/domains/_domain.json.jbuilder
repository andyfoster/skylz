# frozen_string_literal: true

json.extract! domain, :id, :user_id, :created_at, :updated_at
json.url domain_url(domain, format: :json)
