class CommandPolicy < ApplicationPolicy
  def index?
    logged_in?
  end
end
