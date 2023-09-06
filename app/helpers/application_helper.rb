# frozen_string_literal: true

# Mix helper
module ApplicationHelper
  def item_in_session?(item)
    if session[:cart].present?
      session[:cart].each do |cart|
        return true if item == cart[0]
      end
    end
    false
  end
end
