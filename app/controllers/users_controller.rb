class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
    @orders = @user.orders
  end

  def edit
    @user = current_user
  end

  def admin?
    self.admin
  end

  private

  def set_user
    @user = current_user
  end
end
