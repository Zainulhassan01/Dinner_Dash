# frozen_string_literal: true

# Customer controller action
class OrdersController < ApplicationController
  before_action :find_order, only: %i[show update]
  before_action :create_session, only: %i[index]

  def index
    @orders = if admin?
                Order.restaurant_orders(params[:restaurant_id])
              else
                Order.user_orders(params[:user_id], params[:restaurant_id])
              end
    authorize @orders
    session[:restaurant_id] = params[:restaurant_id]
  end

  def show
    authorize @order
    @itemorders = Order.find_orders_in_item_order(params[:id])
  end

  def update
    authorize @order
    if @order.update(status: params[:status], restaurant_id: @order.restaurant_id, user_id: @order.user_id,
                     total: @order.total)
      redirect_back(fallback_location: root_path)
    else
      flash[:alert] = @order.errors.full_messages
      redirect_to(request.referer || root_path)
    end
  end

  def search
    @orders = if params[:status].present? && params[:status] != 'All'
                Order.all.where(status: params[:status], restaurant_id: session[:restaurant_id])
              else
                Order.restaurant_orders(session[:restaurant_id])
              end
    authorize @orders
  end

  private

  def find_order
    @order = Order.find(params[:id])
  end

  def create_session
    session[:restaurant_id] ||= {} if session[:restaurant_id].nil?
  end

  def admin?
    User.find(params[:user_id]).admin?
  end
end
