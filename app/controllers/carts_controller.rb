# frozen_string_literal: true

# carts controller
class CartsController < ApplicationController
  include CartHandler
  before_action :find_item, only: %i[create update]
  before_action :authenticate_user!, only: %i[checkout]
  before_action :find_cart, only: %i[update]
  before_action :find_total_carts, only: %i[checkout]
  before_action :update_cart, only: %i[destroy]

  def index
    if current_user.present?
      check_for_nul = Cart.cart_find
      @carts, @total = CartService.new(check_for_nul, params[:id]).show_carts
    else
      @carts = Cart.cart_find
      @total = Cart.all.sum(:subtotal)
    end
    authorize @carts
  end

  def create
    subtotal = @item.price
    cart = Cart.create!(item_id: @item.id, user_id: current_user.present? ? current_user.id : nil, quantity: 1, subtotal: subtotal)
    authorize cart
    redirect_back(fallback_location: root_path)
    flash[:notice] = 'Item has been added.'
  end

  def update
    if @cart_present
      if item_present?(params[:item_id])
        quantity_updation(params[:status], @cart)
        subtotal = CartService.new(params[:remove], @item, @cart).update_cart
        if @cart.update!(item_id: params[:item_id], user_id: current_user.present? ? current_user.id : nil, quantity: @cart.quantity,
                         subtotal: subtotal)
          authorize @cart
          redirect_back(fallback_location: root_path)
        end
      else
        create
      end
    else
      create
    end
  end

  def checkout
    authorize @carts
    create_order_according_to_cart(@carts, @total)
    redirect_to root_path, notice: 'Order has been placed.' if Cart.where(user_id: params[:id]).delete_all
  end

  def destroy
    cart = Cart.all
    authorize cart
    if current_user.nil?
      redirect_to root_path, notice: 'Cart has been cleared.' if Cart.where('user_id is null').delete_all
    else
      Cart.where(user_id: current_user.id).delete_all
      redirect_to root_path, notice: 'Cart has been cleared.'
    end
  end

  private

  def find_item
    @item = Item.find_by(id: params[:item_id])
  end

  def update_cart
    Cart.where('user_id is null').update_all(user_id: current_user.id) if current_user.present? # rubocop:disable Rails/SkipsModelValidations
  end

  def find_total_carts
    @carts = Cart.find_user_cart(params[:id])
    @total = Cart.calculate_total(params[:id])
  end

  def quantity_updation(status, cart)
    return if status.blank?

    to_boolean(status) ? cart.quantity += 1 : cart.quantity -= 1
  end

  def find_cart
    update_cart
    @cart_present = Cart.find_by(user_id: current_user.present? ? current_user.id : nil).present?
    @cart = Cart.find_by(item_id: params[:item_id])
  end
end
