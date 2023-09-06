# frozen_string_literal: true

class Cart < ApplicationRecord
  has_many :items, dependent: :destroy
  belongs_to :user

  scope :find_orders, ->(restaurant_id) { Order.all.where(restaurant_id: restaurant_id) }
end
