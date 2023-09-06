# frozen_string_literal: true

# cart policy
class CartPolicy < ApplicationPolicy
  def index?
    true
  end

  def create?
    true
  end

  def update?
    true
  end

  def checkout?
    true
  end

  def destroy?
    true
  end
end
