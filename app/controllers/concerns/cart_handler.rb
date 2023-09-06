# frozen_string_literal: true


# Cart helper
module CartHandler
  def item_present?(id)
    Cart.find_by(item_id: id).present?
  end

  def create_order_according_to_cart(carts, total)
    carts.each do |cart|
      item = Item.find_by(id: cart.item_id)
      restaurant_id = item.restaurant_id
      order_create(cart, restaurant_id, total)
    end
  end

  def order_create(cart, restaurant_id, total)
    order = Order.find_or_create_by(user_id: params[:id], restaurant_id: restaurant_id, status: 0, total: total.to_i)
    if order.new_record?
      ItemOrder.find_or_create_by!({ order_id: order.id, quatity: cart.quantity.to_i, subtotal: cart.subtotal.to_i,
                                     item_id: cart.item_id })
    else
      @orders = Cart.find_orders(restaurant_id)
      ItemOrder.create!({ order_id: @orders.last.id, quatity: cart.quantity.to_i, subtotal: cart.subtotal.to_i,
                          item_id: cart.item_id })
    end
  end
end
