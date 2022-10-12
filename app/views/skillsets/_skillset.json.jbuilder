# frozen_string_literal: true

json.extract! skillset, :id, :user_id, :created_at, :updated_at
json.url skillset_url(skillset, format: :json)
