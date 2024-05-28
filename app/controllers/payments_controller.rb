class PaymentsController < ApplicationController
  def new
  end

  def create
    @amount = 500 # Amount in cents

    customer = Stripe::Customer.create({
      email: params[:stripeEmail],
      source: params[:stripeToken],
    })

    charge = Stripe::Charge.create({
      customer: customer.id,
      amount: @amount,
      description: 'Rails Stripe customer',
      currency: 'usd',
    })

    redirect_to root_path, notice: 'Payment was successful'
  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to new_payment_path
  end


end
