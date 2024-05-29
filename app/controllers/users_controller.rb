class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user

  def show
    @user = User.find(params[:id])
    @orders = @user.orders
  end

  def edit
    @user = current_user
  end

  private

  def set_user
    @user = current_user
  end
end
