# frozen_string_literal: true

class Order < ApplicationRecord
    belongs_to :user
    belongs_to :restaurant
    has_many :item_orders, dependent: :destroy
    has_many :items, through: :item_orders, dependent: :destroy
  
    scope :order_finder, ->(user_id, restaurant_id) { where('user_id = ? and restaurant_id = ?', user_id, restaurant_id) }
    scope :order_finder_restaurant, ->(restaurant_id) { where(restaurant_id: restaurant_id) }
    scope :order_status, ->(status, restaurant_id) { where('status = ? and restaurant_id = ?', status, restaurant_id) }
    scope :item_order, ->(id) { ItemOrder.all.where(order_id: id) }
  
    validates :status, numericality: { only_integer: true }
    validates :total, numericality: { only_integer: true, greater_than: 0 }
    enum status: {
      ordered: 0,
      completed: 1,
      cancelled: 2
    }
  end
  