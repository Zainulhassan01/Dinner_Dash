# frozen_string_literal: true

# categories action controller
class CategoriesController < ApplicationController
  before_action :find_restaurant, only: %i[destroy create index]
  before_action :find_category, only: %i[destroy]

  def index
    @categories = @restaurant.categories
    authorize @categories
  end

  def new
    @category = Category.new
    authorize @category
  end

  def create
    @category = @restaurant.categories.new(category_params)
    authorize @category
    if @category.save
      redirect_to @restaurant
    else
      render 'new'
    end
  end

  def destroy
    authorize @category
    redirect_to restaurant_categories_path if @category.destroy!
  end

  private

  def find_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
  end

  def find_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name)
  end
end
