# frozen_string_literal: true

# Category Policy Authorization
class CategoryPolicy < ApplicationPolicy
    def index?
      true
    end
  
    def new?
      user ? user.admin? : false
    end
  
    def create?
      user ? user.admin? : false
    end
  
    def destroy?
      user ? user.admin? : false
    end
end
  