class AddItemsToRestaurant < ActiveRecord::Migration[5.2]
  def change
    add_reference :items, :restaurant, null: false, foreign_key: true, default: 0
    add_reference :categories, :restaurant, null: false, foreign_key: true, default: 0
  end
end
