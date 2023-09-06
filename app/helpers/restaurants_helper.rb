# frozen_string_literal: true

# MOdeule helper for Restaurants
module RestaurantsHelper
  def user_auth?(current_user)
    current_user.nil? || !current_user&.admin?
  end

  def popular_item?(item)
    orders = ItemOrder.all.where(item_id: item.id)
    orders.count >= 7
  end
end
  