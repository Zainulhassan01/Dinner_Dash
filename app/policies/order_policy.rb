# frozen_string_literal: true

# order Policy Authorization
class OrderPolicy < ApplicationPolicy
  def index?
    user
  end

  def show?
    user
  end

  def update?
    user.admin?
  end

  def search?
    user.admin?
  end
end
