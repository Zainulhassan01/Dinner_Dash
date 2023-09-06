# frozen_string_literal: true

# carts controller
class CartsController < ApplicationController
  include CartHandler
  before_action :find_item, only: %i[create update]
  before_action :authenticate_user!, only: %i[checkout]
  before_action :find_cart, only: %i[update]

  def index
    @carts = session[:cart].presence ? session[:cart] : nil
    if current_user
      byebug
      @carts = cart_to_session
    end
    # change view for log in user to render their prev cart
    # authorize @carts
  end

  def create
    session[:cart][@item.title] = 1
    if current_user
      cart = Cart.create!(item_id: @item.id, user_id: current_user.id, quantity: 1, subtotal: @item.price * 1)
      authorize cart
    end
    flash[:notice] = 'Item has been added.'
    redirect_back(fallback_location: root_path)
  end

  def update
    if session[:cart][@item.title].present?
      session[:cart][@item.title] = quantity_updation(params[:status])
      to_boolean(params[:remove]) ? session[:cart].delete(@item.title) && redirect_back(fallback_location: root_path) && return : nil
      check_count?(session[:cart][@item.title]) ? redirect_back(fallback_location: root_path) && return : nil

      if current_user
        @cart.update!(item_id: @item.id, user_id: current_user.id, quantity: session[:cart][@item.title],
                      subtotal: @item.price * session[:cart][@item.title])
        authorize @cart
      end
      redirect_back(fallback_location: root_path)
    else
      create
    end
  end

  def checkout
    # authorize @carts
    create_order_according_to_cart(session[:cart], params[:total])
    Cart.delete_all
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
    count = session[:cart][@item.title]
    to_boolean(status) ? count += 1 : count -= 1
    count
  end

  def find_cart
    session[:cart] ||= {} if session[:cart].nil?
    @cart = Cart.find_by(item_id: params[:item_id])
  end

  def check_count?(count)
    if count.zero?
      session[:cart].delete(@item.title)
      return true
    end
    false
  end

  def cart_to_session
    session[:cart] ||= {} if session[:cart].nil?
    @carts = Cart.all.where(user_id: current_user.id)
    @carts.each do |cart|
      item = Item.find_by(id: cart.item_id)
      session[:cart][item.title] = cart.quantity
    end
    session[:cart]
  end
end
