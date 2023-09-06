# frozen_string_literal: true

# MOdeule helper for items
module ItemsHelper
  def item_nil?(current_user, items)
    current_user&.admin? || items.nil?
  end
end
  