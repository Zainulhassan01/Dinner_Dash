# frozen_string_literal: true

class Category < ApplicationRecord
    belongs_to :restaurant
    has_many :item_categories, dependent: :destroy
    has_many :items, through: :item_categories, dependent: :destroy
  
    validates :name, presence: true, length: { minimum: 3, maximum: 10 }
    validates_with CustomValidator, on: :create
  end
  