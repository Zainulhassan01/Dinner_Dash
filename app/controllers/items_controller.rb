# frozen_string_literal: true

# Items Controller Action
class ItemsController < ApplicationController
    before_action :find_category, only: %i[index create]
    before_action :find_item, only: %i[edit update show destroy]
    before_action :find_itemcategory, only: %i[new create edit]
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
        create_itemcategory(@item, params[:names], params[:restaurant_id])
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
      if @item.update!(item_params)
        create_itemcategory(@item, params[:names], params[:restaurant_id])
        redirect_to restaurant_category_items_path
      else
        render 'edit'
      end
    end
  
    def destroy
      authorize @item
      redirect_to restaurant_category_items_path if @item.destroy!
    end
  
    def retire
      @item = Item.find(params[:id])
      authorize @item
      @item.available = !@item.available
      if @item.update(params.permit(:title, :description, :price, :available))
        redirect_back(fallback_location: root_path)
        flash[:alert] = 'Item Updated.'
      else
        render 'edit'
      end
    end
  
    private
  
    def find_item
      @item = Item.find(params[:id])
      @categories = Category.all
    end
  
    # create item_category
    def create_itemcategory(item, names, resturant)
      names.each do |name|
        category = Category.find_by(name: name, restaurant_id: resturant)
        ItemCategory.create!(item_id: item.id, category_id: category.id)
      end
    end
  
    def find_category
      @category = Category.find(params[:category_id])
    end
  
    def item_params
      params.require(:item).permit(:title, :description, :price, :available, :image)
    end
  
    def find_itemcategory
      @categories = Item.category_item(params[:restaurant_id])
    end
  end
  