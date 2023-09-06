# frozen_string_literal: true

# carts controller
class CartsController < ApplicationController
  include CartHandler
  before_action :authenticate_user!, only: %i[checkout]
  before_action :create_session, only: %i[update]
  around_action :update_cart, only: %i[update quantity]

  def index
    @carts = session[:cart].presence ? session[:cart] : nil
    @carts = cart_to_session if current_user
  end

  def create
    session[:cart][params[:item_title]] = 1
    if current_user
      item = Item.find_by(title: params[:item_title])
      Cart.create!(item_id: item.id, user_id: current_user.id, quantity: 1, subtotal: item.price * 1)
    end
    flash[:notice] = 'Item has been added.'
    redirect_back(fallback_location: root_path)
  end

  def update
    if session[:cart][params[:item_title]].present?
      if to_boolean(params[:remove])
        session[:cart].delete(params[:item_title])
        removeitem(params[:item_title])
        flash[:notice] = 'Item has been removed.'
        redirect_back(fallback_location: root_path)
      end
    else
      create
    end
  end

  def quantity
    count = quantity_updation(params[:status])
    session[:cart][params[:item_title]] = count
    check_count?(session[:cart][params[:item_title]])
    @carts = session[:cart]
  end

  def checkout
    populate_cart
    create_order_according_to_cart(session[:cart], params[:total])
    Cart.where(user_id: current_user.id).delete_all
    redirect_to root_path, notice: 'Order has been placed.' if session.delete(:cart)
  end

  def destroy
    session.delete(:cart)
    Cart.where(user_id: current_user.id).delete_all if current_user
    flash[:notice] = 'Cart has been cleared.'
    redirect_to root_path
  end

  private

  def create_session
    session[:cart] ||= {} if session[:cart].nil?
  end

  def cart_to_session
    session[:cart] ||= {} if session[:cart].nil?
    @carts = Cart.where(user_id: current_user.id)
    @carts.each do |cart|
      item = Item.find_by(id: cart.item_id)
      session[:cart][item.title] = cart.quantity if item.available
    end
    session[:cart]
  end

  def update_cart
    ActiveRecord::Base.transaction do
      yield
      check_user
    end
  end

  def check_user
    if current_user
      populate_cart unless Cart.nil?
      item = Item.find_by(title: params[:item_title])
      cart = Cart.find_by(item_id: item.id)
      if cart&.present?
        cart.update!(item_id: item.id, user_id: current_user.id, quantity: session[:cart][params[:item_title]].to_i,
                     subtotal: item.price * session[:cart][params[:item_title]].to_i)
      end
    end
    flash[:alert] = 'Cart is not destroyed.' unless Cart.where(quantity: 0).delete_all
  end

  def populate_cart
    return unless current_user

    @carts = session[:cart]
    @carts.each do |cart|
      item = Item.find_by(title: cart[0])
      cart_model = Cart.find_by(item_id: item.id)
      if !cart_model.nil?
        cart_model.update!(item_id: item.id, user_id: current_user.id, quantity: cart[1].to_i,
                           subtotal: item.price * cart[1].to_i)
      else
        Cart.create!(item_id: item.id, user_id: current_user.id, quantity: cart[1].to_i,
                     subtotal: item.price * cart[1].to_i)
      end
    end
  end
end
