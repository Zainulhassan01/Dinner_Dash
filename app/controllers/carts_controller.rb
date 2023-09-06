# frozen_string_literal: true

# carts controller
class CartsController < ApplicationController
  include CartHandler
  before_action :find_item, only: %i[create update]
  before_action :authenticate_user!, only: %i[checkout]
  before_action :find_cart, only: %i[update]
  after_action :update_cart, only: %i[update quantity]

  def index
    @carts = session[:cart].presence ? session[:cart] : nil
    # handle multiple items with same name in cart
    @carts = cart_to_session if current_user
    # byebug
  end

  def create
    session[:cart][params[:item_title]] = 1
    if current_user
      item = Item.find_by(title: params[:item_title])
      cart = Cart.create!(item_id: item.id, user_id: current_user.id, quantity: 1, subtotal: item.price * 1)
      authorize cart
    end
    flash[:notice] = 'Item has been added.'
    redirect_back(fallback_location: root_path)
  end

  def update
    if session[:cart][params[:item_title]].present?
      to_boolean(params[:remove]) ? session[:cart].delete(params[:item_title]) && redirect_back(fallback_location: root_path) && return : nil
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
    @carts = session[:cart]
    @carts.each do |cart|
      item = Item.find_by(title: cart[0])
      Cart.create!(item_id: item.id, user_id: current_user.id, quantity: session[:cart][item.title],
                   subtotal: item.price * session[:cart][item.title])
    end
    create_order_according_to_cart(session[:cart], params[:total])
    Cart.where(user_id: current_user.id).delete_all
    redirect_to root_path, notice: 'Order has been placed.' if session.delete(:cart)
  end

  def destroy
    session.delete(:cart)
    Cart.delete_all
    flash[:notice] = 'Cart has been cleared.'
    redirect_to root_path
  end

  private

  def find_item
    @item = Item.find_by(id: params[:item_id])
  end

  def quantity_updation(status)
    count = session[:cart][params[:item_title]]
    to_boolean(status) ? count += 1 : count -= 1
    count
  end

  def find_cart
    session[:cart] ||= {} if session[:cart].nil?
    item = Item.find_by(title: params[:item_title])
    @restaurant_id = item.restaurant_id
  end

  def check_count?(count)
    session[:cart].delete(params[:item_title]) if count.zero?
  end

  def update_cart
    item = Item.find_by(title: params[:item_title])
    to_boolean(params[:remove]) ? removeitem(item) && return : nil

    cart = Cart.find_by(item_id: item.id)
    if current_user
      cart.update!(item_id: item.id, user_id: current_user.id, quantity: session[:cart][params[:item_title]].to_i,
                   subtotal: item.price * session[:cart][params[:item_title]].to_i)
    end
  end

  def cart_to_session
    session[:cart] ||= {} if session[:cart].nil?
    @carts = Cart.where(user_id: current_user.id)
    @carts.each do |cart|
      item = Item.find_by(id: cart.item_id)
      session[:cart][item.title] = cart.quantity
    end
    session[:cart]
  end
end
