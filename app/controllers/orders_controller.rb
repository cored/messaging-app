class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_order, only: %i[ show edit update destroy ]

  def new
    @order = Order.new
  end

  # GET /orders or /orders.json
  def index
    @orders = current_user.is_doctor ? current_user.doctor_orders : current_user.orders
    puts "Orders: #{@orders.inspect}"
  end

  # GET /orders/1 or /orders/1.json
  def show
  end

  def update
    if @order.update(order_params)
      redirect_to @order, notice: 'Order was successfully updated.'
    else
      render :edit
    end
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:order_items, :total, :doctor_id, :user_id)
  end
end
