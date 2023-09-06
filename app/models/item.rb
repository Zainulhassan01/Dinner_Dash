# frozen_string_literal: true

# class item model
class Item < ApplicationRecord
  belongs_to :restaurant
  belongs_to :cart, optional: true
  has_many :item_categories, dependent: :destroy
  has_many :categories, through: :item_categories, dependent: :destroy
  has_many :item_orders, dependent: :destroy
  has_many :orders, through: :item_orders, dependent: :destroy
  has_one_attached :image

  after_commit :add_default_cover, on: %i[create update]
  validates :title, :description, presence: true
  validates :price, numericality: { greater_than: 0 }
  validates_with CustomValidator, on: :create

  scope :find_category_items, ->(restaurant_id) { Category.all.where(restaurant_id: restaurant_id) }

  def self.create_item_category(item, names, resturant)
    names.each do |name|
      category = Category.find_by(name: name, restaurant_id: resturant)
      ItemCategory.create!(item_id: item.id, category_id: category.id)
    end
  end

  private

  def add_default_cover
    unless image.attached?
      image.attach(io: File.open(Rails.root.join('app', 'assets', 'images', 'cover.jpeg')), filename: 'cover.jpeg',
                   content_type: 'image/jpeg')
    end
  end
end
