class CartsController < ApplicationController
  before_action :authenticate_user!

  def show
    @cart = current_user.cart
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

  # def cart_params
  #   # Ajoutez ici les paramètres que vous souhaitez autoriser lors de la création ou de la mise à jour du panier
  #   params.require(:cart).permit(:parametre_1, :parametre_2, ...)
  # end
end
