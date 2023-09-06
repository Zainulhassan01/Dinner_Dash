# frozen_string_literal: true

# Customer controller action
class OrdersController < ApplicationController
  before_action :find_order, only: %i[show update]
  @@restaurant_id = 0

  def index
    @orders = if admin?
                Order.restaurant_orders(params[:restaurant_id])
              else
                Order.user_orders(params[:user_id], params[:restaurant_id])
              end
    authorize @orders
    @@restaurant_id = params[:restaurant_id]
  end

  def show
    authorize @order
    @itemorders = Order.find_orders_in_item_order(params[:id])
  end

  def update
    authorize @order
    if @order.update!(status: params[:status], restaurant_id: @order.restaurant_id, user_id: @order.user_id,
                      total: @order.total)
      redirect_back(fallback_location: root_path)
    else
      flash[:alert] = @order.errors.full_messages
      redirect_to(request.referer || root_path)
    end
  end

  def search
    @orders = if params[:status].present? && params[:status] != 'Filter'
                Order.all.where(status: params[:status], restaurant_id: @@restaurant_id)
              else
                Order.restaurant_orders(@@restaurant_id)
              end
    authorize @orders
  end

  private

  def find_order
    @order = Order.find(params[:id])
  end

  def admin?
    User.find(params[:user_id]).admin?
  end
end
