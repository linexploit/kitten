class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
    @orders = @user.orders
  end

  def edit
    @user = current_user
  end
end
