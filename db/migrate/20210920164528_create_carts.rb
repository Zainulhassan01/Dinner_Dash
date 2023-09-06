class CreateCarts < ActiveRecord::Migration[5.2]
  def change
    create_table :carts do |t|
      t.decimal :quantity
      t.decimal :subtotal
      t.references :item, null: false, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
