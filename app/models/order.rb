# frozen_string_literal: true

class Order < ApplicationRecord
  belongs_to :user
  belongs_to :restaurant
  has_many :item_orders, dependent: :destroy
  has_many :items, through: :item_orders, dependent: :destroy

  scope :find_orders_of_user, ->(user_id, restaurant_id) { where(user_id: user_id, restaurant_id: restaurant_id) }
  scope :find_orders_of_restaurant, ->(restaurant_id) { where(restaurant_id: restaurant_id) }
  scope :find_order_according_to_status, ->(status, restaurant_id) { where(status: status, restaurant_id: restaurant_id) }
  scope :find_orders_in_item_order, ->(id) { ItemOrder.all.where(order_id: id) }

  validates :status, numericality: { only_integer: true }
  validates :total, numericality: { only_integer: true, greater_than: 0 }
  enum status: {
    ordered: 0,
    completed: 1,
    cancelled: 2
  }
end
