# frozen_string_literal: true

# Cart helper
module CartsHelper
  def find_total(carts)
    total = 0
    carts.each do |cart|
      item = item_finder(cart)
      unless item.available?
        session[:cart].delete(:item.title)
        break
      end
      total += item.price * cart[1]
    end
    total
  end

  def item_finder(cart)
    Item.find_by(title: cart[0])
  end
end
