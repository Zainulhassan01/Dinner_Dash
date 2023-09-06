class AddDbLevelValidation < ActiveRecord::Migration[5.2]
  def change
    def up
      change_column_null :restaurants, :name, false
      change_column_null :items, :title, false
      change_column_null :items, :description, false
      change_column_null :items, :price, false
      change_column_null :item_orders, :quatity, false
      change_column_null :carts, :quantity, false
      change_column_null :carts, :subtotal, false
      change_column :carts, :quantity, :integer
      change_column :carts, :subtotal, :integer
      change_column :item_orders, :quatity, :integer
      change_column :item_orders, :subtotal, :integer
      change_column :orders, :total, :integer
      change_column :orders, :status, :integer
      add_check_constraint :items, 'price > 0', name: 'price_check'
      add_check_constraint :orders, 'total > 0', name: 'total_check'
      add_check_constraint :item_orders, 'subtotal > 0', name: 'subtotal_check'
      add_check_constraint :carts, 'subtotal > 0', name: 'subtotalcart_check'
    end
  
    def down
      remove_check_constraint :carts, name: 'subtotalcart_check'
      remove_check_constraint :item_orders, name: 'subtotal_check'
      remove_check_constraint :orders, name: 'total_check'
      remove_check_constraint :items, name: 'price_check'
      change_column :orders, :status, :decimal
      change_column :orders, :total, :decimal
      change_column :item_orders, :subtotal, :decimal
      change_column :item_orders, :quatity, :decimal
      change_column :carts, :subtotal, :decimal
      change_column :carts, :quantity, :decimal
      change_column_null :carts, :subtotal, true
      change_column_null :carts, :quantity, true
      change_column_null :item_orders, :quatity, true
      change_column_null :items, :price, true
      change_column_null :items, :description, true
      change_column_null :items, :title, true
      change_column_null :restaurants, :name, true
    end
  end
end
