# frozen_string_literal: true

class Restaurant < ApplicationRecord
    has_many :items, dependent: :destroy
    has_many :categories, dependent: :destroy
    has_many :orders, dependent: :destroy
  
    validates :name, presence: true, length: { minimum: 3, maximum: 10 }
  end
  