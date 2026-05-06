class HomePolicy < ApplicationPolicy
  def index?
    logged_in?
  end
end
