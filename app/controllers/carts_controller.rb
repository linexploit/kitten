class CartsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_cart, only: [:show, :edit, :update, :destroy, :confirm_order]

  def show
    @cart = current_user.cart
    @cart_items = @cart.cart_items
    @total_price = @cart.items.sum(&:price)

  end

  def edit
    @cart = Cart.find(params[:id])
   end

  def create
    @cart = current_user.build_cart
    if @cart.save
      redirect_to @cart, notice: 'Votre panier a été créé avec succès.'
    else
      render :new
    end
  end

  def update
    @cart = current_user.cart
    if @cart.update(cart_params)
      redirect_to @cart, notice: 'Votre panier a été mis à jour avec succès.'
    else
      render :edit
    end
  end

  def destroy
    @cart = current_user.cart
    @cart.destroy
    redirect_to root_path, notice: 'Votre panier a été supprimé avec succès.'
  end

  def add_item
    @cart = current_user.cart || current_user.create_cart
    item = Item.find(params[:item_id])
    @cart.items << item
    redirect_to @cart, notice: 'L\'article a été ajouté à votre panier.'
  end

  def remove_item
    @cart = current_user.cart
    item = Item.find(params[:item_id])
    @cart.items.delete(item)
    redirect_to @cart, notice: 'L\'article a été retiré de votre panier.'
  end

  def confirm_order
    @cart = current_user.cart
    if @cart.items.any?
      order = current_user.orders.create
      @cart.items.each do |item|
        order.order_items.create(item: item)
      end
      @cart.items.clear
      redirect_to order_path(order), notice: 'Votre commande a été passée avec succès.'
    else
      redirect_to @cart, alert: 'Votre panier est vide.'
    end
  end

  private

  def set_cart
    @cart = current_user.cart || current_user.create_cart
  end

  def cart_params
    params.require(:cart).permit(:user_id)
  end
end
