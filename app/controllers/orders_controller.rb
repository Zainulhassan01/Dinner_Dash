# frozen_string_literal: true

# Customer controller action
class OrdersController < ApplicationController
    before_action :find_order, only: %i[show update]
    @@restaurant_id = 0
  
    def index
      @orders = if params[:user_id] && !to_boolean(params[:admin])
                  Order.all.order_finder(params[:user_id], params[:restaurant_id])
                elsif params[:user_id] && to_boolean(params[:admin])
                  Order.all.order_finder_restaurant(params[:restaurant_id])
                end
      authorize @orders
      @@restaurant_id = params[:restaurant_id]
    end
  
    def show
      authorize @order
      @itemorders = Order.item_order(params[:id])
    end
  
    def update
      authorize @order
      if @order.update!(status: params[:status].to_i, restaurant_id: @order.restaurant_id, user_id: @order.user_id,
                        total: @order.total.to_i)
        redirect_back(fallback_location: root_path)
      end
    end
  
    def search
      if params[:status].present? && params[:status].to_i != 1
        status = params[:status].to_i - 2
        @orders = Order.all.order_status(status, @@restaurant_id)
      elsif current_user&.admin?
        @orders = Order.all.order_finder_restaurant(@@restaurant_id)
      end
      authorize @orders
    end
  
    private
  
    def find_order
      @order = Order.find(params[:id])
    end
  end
  