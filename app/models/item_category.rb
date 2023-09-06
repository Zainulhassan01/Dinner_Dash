# frozen_string_literal: true

# item category bridge table
class ItemCategory < ApplicationRecord
  belongs_to :item
  belongs_to :category

  def self.create_item_category(item, names, resturant)
    names.each do |name|
      category = Category.find_by(name: name, restaurant_id: resturant)
      ItemCategory.create!(item_id: item.id, category_id: category.id)
    end
  end
end
