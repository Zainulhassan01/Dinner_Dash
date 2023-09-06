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
end
  