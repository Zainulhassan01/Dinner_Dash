# frozen_string_literal: true

class CreateItemCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :item_categories do |t|
      t.references :item, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
