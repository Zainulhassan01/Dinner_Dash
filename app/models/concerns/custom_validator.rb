# frozen_string_literal: true

# Custom validations
class CustomValidator < ActiveModel::Validator
  def validate(record)
    restaurant = record.restaurant_id
    itemsinrestaurant = Item.where('restaurant_id = ?', restaurant)
    categoriessinrestaurant = Category.where('restaurant_id = ?', restaurant)
    if record.try(:title)
      itemsinrestaurant.each do |itm|
        record.errors.add :title, 'already exist.' if itm.title == record.title
      end
    else
      categoriessinrestaurant.each do |cat|
        record.errors.add :name, 'already exist.' if cat.name == record.name
      end
    end
  end
end
