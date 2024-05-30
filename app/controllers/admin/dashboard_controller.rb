module Admin
  class DashboardController < ApplicationController
    before_action :authenticate_user!
    before_action :check_if_admin

    def index
      @orders_count = Order.count
      @average_price = Order
      # Ajoutez d'autres statistiques nécessaires ici
    end

    private

    def check_if_admin
      redirect_to(root_path) unless current_user.admin?
    end
  end
end
