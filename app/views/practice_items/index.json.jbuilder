# frozen_string_literal: true

json.array! @practice_items, partial: 'practice_items/practice_item', as: :practice_item
