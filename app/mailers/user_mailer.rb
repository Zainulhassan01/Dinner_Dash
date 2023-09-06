# frozen_string_literal: true

class UserMailer < ApplicationMailer
  default from: 'zain.hassan@devsinc.com'

  def registration_confirmation(user)
    @user = user
    mail(to: @user.email, subject: 'Registered')
  end
end
