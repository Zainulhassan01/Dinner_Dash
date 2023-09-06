# frozen_string_literal: true

# categories action controller
class CategoriesController < ApplicationController
  before_action :find_restaurant, only: %i[destroy create index]
  before_action :find_category, only: %i[destroy]

  def index
    @categories = Category.includes(:restaurant).where(restaurants: { id: params[:restaurant_id] })
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
    @category.destroy!
    flash[:notice] = 'Category has been deleted.'
    redirect_to restaurant_categories_path
  end

  private

  def find_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
  end

  def find_category
    @category = @restaurant.categories.find(params[:id]) if @restaurant
  end

  def category_params
    params.require(:category).permit(:name)
  end
end
