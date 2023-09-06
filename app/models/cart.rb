# frozen_string_literal: true

class Cart < ApplicationRecord
  has_many :items, dependent: :destroy
  belongs_to :user, optional: true

  scope :find_user_cart, ->(user_id) { where(user_id: user_id) }
  scope :calculate_total, ->(user_id) { where(user_id: user_id).sum(:subtotal) }
  scope :cart_find, -> { Cart.all.where('user_id is null') }
  scope :find_orders, ->(restaurant_id) { Order.all.where(restaurant_id: restaurant_id) }
end
