# frozen_string_literal: true

# Userdevise Model
class User < ApplicationRecord
  validates :full_name, presence: true
  validates :display_name, length: { minimum: 2, maximum: 32 }, if: :display_name?

  has_many :orders, dependent: :destroy
  has_one :cart, dependent: :delete

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
