# frozen_string_literal: true

# Module Helper for customers/orders
module OrdersHelper
    def find_item_name(item)
      item_type = Item.find(item)
      item_type.title
    end
  
    def order_present?(current_user, order)
      current_user&.admin? && order.present?
    end
  
    def order_admin?(current_user, order)
      current_user && order.present? && current_user.id == order.user_id
    end
end
  