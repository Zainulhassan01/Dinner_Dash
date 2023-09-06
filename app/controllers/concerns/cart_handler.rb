# frozen_string_literal: true

# top level definition

# Cart helper
module CartHandler
    def removeitem(item)
      cart = Cart.find_by(item_id: item.id)
      Cart.delete(cart.id)
    end
  
    def item_present?(id)
      Cart.find_by(item_id: id) ? true : false
    end
    def order_create(cart, restaurant_id, total)
      order = Order.find_or_create_by(user_id: params[:id], restaurant_id: restaurant_id, status: 0, total: total.to_i)
      if order.new_record?
        ItemOrder.find_or_create_by!({ order_id: Order.last.id, quatity: cart.quantity.to_i, subtotal: cart.subtotal.to_i,
                                       item_id: cart.item_id })
      else
        @orders = Cart.orders_finder(restaurant_id)
        ItemOrder.create!({ order_id: @orders.last.id, quatity: cart.quantity.to_i, subtotal: cart.subtotal.to_i,
                            item_id: cart.item_id })
      end
    end
end
  