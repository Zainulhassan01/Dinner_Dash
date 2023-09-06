# frozen_string_literal: true

class CartPolicy < ApplicationPolicy
    def index?
      user ? true : User.last.id + 1
    end
  
    def update?
      user ? true : User.last.id + 1
    end
  
    def create?
      user ? true : User.last.id + 1
    end
  
    def checkout?
      user ? true : User.last.id + 1
    end
  
    def destroy?
      user ? true : User.last.id + 1
    end
end
  