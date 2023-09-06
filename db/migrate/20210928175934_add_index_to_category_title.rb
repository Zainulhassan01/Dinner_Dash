# frozen_string_literal: true

class AddIndexToCategoryTitle < ActiveRecord::Migration[5.2]
  def change
    add_index :categories, %i[restaurant_id name], unique: true
    add_index :items, %i[restaurant_id title], unique: true
  end
end
