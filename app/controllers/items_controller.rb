# frozen_string_literal: true

# Items Controller Action
class ItemsController < ApplicationController
  before_action :find_category, only: %i[index create]
  before_action :find_item, only: %i[edit update show destroy retire]
  before_action :find_item_category, only: %i[new create edit]

  def index
    @items = @category.items
    authorize @items
  end

  def new
    @item = Item.new
    authorize @item
  end

  def create
    @item = @category.items.new(item_params.merge(restaurant_id: params[:restaurant_id]))
    authorize @item
    if @item.save
      ItemCategory.create_item_category(@item, params[:names], params[:restaurant_id])
      redirect_to restaurant_category_items_path
    else
      render 'new'
    end
  end

  def show; end

  def edit
    authorize @item
  end

  def update
    authorize @item
    if @item.update(item_params)
      ItemCategory.create_item_category(@item, params[:names], params[:restaurant_id])
      redirect_to restaurant_category_items_path
    else
      render 'edit'
    end
  end

  def destroy
    authorize @item
    @item.destroy!
    flash[:notice] = 'Item has been deleted.'
    redirect_to restaurant_category_items_path
  end

  def retire
    authorize @item
    if @item.update(available: !@item.available)
      redirect_back(fallback_location: root_path)
      flash[:notice] = 'Item Updated.'
    else
      render 'edit'
    end
  end

  private

  def find_item
    @item = Item.find(params[:id])
    @categories = Category.all
  end

  def find_category
    @category = Category.find(params[:category_id])
  end

  def item_params
    params.require(:item).permit(:title, :description, :price, :available, :image)
  end

  def find_item_category
    @categories = Item.find_category_items(params[:restaurant_id])
  end
end
