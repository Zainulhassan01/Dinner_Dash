# frozen_string_literal: true

# item Policy Authorization
class ItemPolicy < ApplicationPolicy
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
  
    def retire?
      user ? user.admin? : false
    end
end
  