# frozen_string_literal: true

# Mix helper
module ApplicationHelper
    def guest_user
      session[:user_id] = User.last.id + 1
    end
end
  