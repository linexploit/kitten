class OrdersController < ApplicationController
  before_action :authenticate_user!

  def new
    @order = current_user.orders.build
    @cart = current_user.cart
    @total_price = @cart.items.sum(&:price)
  end

  def create
    @order = current_user.orders.build(order_params)
    @cart = current_user.cart
    @total_price = @cart.items.sum(&:price)

    if @order.save
      # Associate cart items with the order
      @cart.items.each do |item|
        @order.order_items.create(item: item, price: item.price)
      end
      # Clear the cart
      @cart.items.clear

      redirect_to @order, notice: 'Votre commande a été passée avec succès.'
    else
      render :new
    end
  end

  def show
    @order = Order.find(params[:id])
  end

  private

  def order_params
    params.require(:order).permit(:total_price)
  end
end
