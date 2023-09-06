# frozen_string_literal: true

# Cart helper
module CartsHelper
    def item_finder(cart)
      item = cart.item_id
      Item.all.find_by(id: item).title
    end
end
  