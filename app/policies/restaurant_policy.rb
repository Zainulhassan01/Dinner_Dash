# frozen_string_literal: true

# Polcy for authorization
class RestaurantPolicy < ApplicationPolicy
    def index?
      true
    end
  
    def new?
      user ? user.admin? : false
    end
  
    def create?
      user ? user.admin? : false
    end
  
    def show?
      true
    end
  
    def edit?
      user ? user.admin? : false
    end
  
    def update?
      user ? user.admin? : false
    end
  
    def destroy?
      user ? user.admin? : false
    end
end
  