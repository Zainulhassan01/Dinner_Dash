# frozen_string_literal: true

# skim cart,order controller, cart,order policy
class CartsController < ApplicationController
  include CartHandler
  before_action :find_item, only: %i[create update]
  before_action :authenticate_user!, only: %i[customvalid]
  before_action :set_cart, only: %i[customvalid]

  def index
    if current_user.present?
      check = Cart.cart_find
      if check.blank?
        @carts = Cart.all.user_cart(params[:id])
        @total = Cart.total(params[:id])
      else
        @carts = check
        @total = check.sum(:subtotal)
      end
    else
      @carts = Cart.cart_find
      @total = Cart.all.sum(:subtotal)
    end
    authorize @carts
  end

  def create(id)
    count = 1
    item = Item.find_by(id: id)
    subtotal = item.price
    cart = Cart.create!(item_id: id, user_id: current_user.present? ? current_user.id : nil, quantity: count, subtotal: subtotal)
    authorize cart
    redirect_back(fallback_location: root_path)
    flash[:notice] = 'Item has been added.'
  end

  def update
    if Cart.any?
      cart = Cart.find_by(item_id: params[:item_id])
      if item_present?(params[:item_id])
        if params[:status].present?
          to_boolean(params[:status]) ? cart.quantity += 1 : cart.quantity -= 1
        end
        to_boolean(params[:remove]) ? removeitem(@item) : nil
        removeitem(@item) if cart.quantity.zero?
        unless Cart.exists?
          redirect_to root_path, notice: 'No cart to display.'
          return
        end
        subtotal = @item.price * cart.quantity
        if cart.update!(item_id: params[:item_id], user_id: current_user.present? ? current_user.id : nil, quantity: cart.quantity, subtotal: subtotal)
          authorize cart
          redirect_back(fallback_location: root_path)
        end
      else
        create(params[:item_id])
      end
    else
      create(params[:item_id])
    end
  end

  def customvalid
    total = Cart.total(params[:id])
    carts = Cart.all.user_cart(params[:id])
    authorize carts
    carts.each do |cart|
      item = Item.find_by(id: cart.item_id)
      restaurant_id = item.restaurant_id
      order_create(cart, restaurant_id, total)
    end
    redirect_to root_path, notice: 'Order has been placed.' if Cart.where(user_id: params[:id]).delete_all
  end

  def destroy
    authorize Cart
    if current_user.nil?
      redirect_to root_path, notice: 'Cart has been cleared.' if Cart.where('user_id is null').delete_all
    else
      set_cart
      Cart.where(user_id: current_user.id).delete_all
      redirect_to root_path, notice: 'Cart has been cleared.'
    end
  end

  private

  def find_item
    @item = Item.find_by(id: params[:item_id])
  end

  def set_cart
    Cart.where('user_id is null').update_all(user_id: params[:id]) # rubocop:disable Rails/SkipsModelValidations
  end
end
