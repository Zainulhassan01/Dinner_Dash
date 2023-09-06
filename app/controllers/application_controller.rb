# frozen_string_literal: true

# ApplicationController
class ApplicationController < ActionController::Base
  include Pundit
  # include ExceptionHandler
  include ApplicationHelper
  before_action :configure_permitted_parameters, if: :devise_controller?

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |usr| usr.permit(:full_name, :email, :password, :display_name) }
  end

  def to_boolean(str)
    str == 'true'
  end
end
