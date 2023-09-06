class CreateItemOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :item_orders do |t|
      t.decimal :quatity
      t.decimal :subtotal
      t.references :order, null: false, foreign_key: true
      t.references :item, null: false, foreign_key: true

      t.timestamps
    end
  end
end
