# frozen_string_literal: true

# Home page controller
class RestaurantsController < ApplicationController
  before_action :find_restaurant, only: %i[destroy show]

  def index
    @restaurants = Restaurant.all
    authorize @restaurants
  end

  def new
    @restaurant = Restaurant.new
    authorize @restaurant
  end

  def create
    @restaurant = Restaurant.new(restaurant_params)

    authorize @restaurant
    if @restaurant.save
      redirect_to root_path, notice: 'Restaurant Created.'
    else
      render 'new'
    end
  end

  def show
    authorize @restaurant
    if @restaurant
      @items = @restaurant.items
    else
      flash[:alert] = @restaurant.errors.full_messages
      redirect_to(request.referer || root_path)
    end
  end

  def destroy
    authorize @restaurant
    redirect_to root_path, notice: 'Restaurant Deleted.' if @restaurant.destroy!
  end

  private

  def find_restaurant
    @restaurant = Restaurant.find_by!(id: params[:id])
  end

  def restaurant_params
    params.require(:restaurant).permit(:name)
  end
end
