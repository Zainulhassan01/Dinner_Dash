# frozen_string_literal: true

# Handling exceptions
module ExceptionHandler
  extend ActiveSupport::Concern

  included do
    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
    rescue_from ActiveRecord::RecordInvalid, with: :record_invalid

    private

    def user_not_authorized
      flash[:alert] = 'You are not authorized to perform this action.'
      redirect_to(request.referer || root_path)
    end

    def record_not_found
      flash[:alert] = 'Record Not Found.'
      redirect_to(request.referer || root_path)
    end

    def record_invalid
      flash[:alert] = 'Record Invalid.'
      redirect_to(request.referer || root_path)
    end
  end
end
