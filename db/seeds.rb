# frozen_string_literal: true

Restaurant.create!([{ name: 'Hardees' }, { name: 'NY212' }])

User.create!([{ email: 'demo+rachel@jumpstartlab.com', password: 'password', full_name: 'Rachel Warbelow' },
              { email: 'demo+jeff@jumpstartlab.com', password: 'password', full_name: 'Jeff Casimir',
                display_name: 'j3' },
              { email: 'demo+jorge@jumpstartlab.com', password: 'password', full_name: 'Jorge Tellez',
                display_name: 'novohispano' },
              { email: 'demo+josh@jumpstartlab.com', password: 'password', full_name: 'Josh Cheek',
                display_name: 'josh', admin: true }])

names = ['Pizza', 'Pizzabbq', 'Platter', 'Shwarma', 'Burger', 'Biryani', 'Karahi', 'Chinese Rice', 'Salad', 'Ice cream']
prices = [500, 700, 200, 150, 220, 250, 900, 300, 100, 80]
categories = ['Fast Food', 'Desi', 'Rice', 'Sweets', 'Vegetable']

names.zip(prices).each do |name, price|
  Item.create!({ title: name, description: 'Must Try atleast One time thing.', price: price, restaurant_id: 1 })
end

categories.each do |cat|
  Category.create!({ name: cat, restaurant_id: 1 })
end

ItemCategory.create!([{ category_id: 1, item_id: 1 }, { category_id: 1, item_id: 2 }, { category_id: 1, item_id: 3 },
                      { category_id: 1, item_id: 4 }, { category_id: 1, item_id: 5 }, { category_id: 2, item_id: 6 },
                      { category_id: 2, item_id: 7 }, { category_id: 3, item_id: 8 }, { category_id: 3, item_id: 6 },
                      { category_id: 4, item_id: 10 }, { category_id: 5, item_id: 9 }])

Order.create!([{ user_id: 1, restaurant_id: 1, total: 500, status: 0 },
               { user_id: 1, restaurant_id: 1, total: 700, status: 1 },
               { user_id: 2, restaurant_id: 1, total: 650, status: 0 },
               { user_id: 2, restaurant_id: 1, total: 900, status: 2 },
               { user_id: 3, restaurant_id: 1, total: 1000, status: 1 },
               { user_id: 3, restaurant_id: 1, total: 1700, status: 2 }])

ItemOrder.create!([{ quatity: 1, subtotal: 500, order_id: 1, item_id: 1 },
                   { quatity: 1, subtotal: 500, order_id: 2, item_id: 1 },
                   { quatity: 1, subtotal: 200, order_id: 2, item_id: 3 },
                   { quatity: 1, subtotal: 500, order_id: 3, item_id: 1 },
                   { quatity: 1, subtotal: 150, order_id: 3, item_id: 4 },
                   { quatity: 1, subtotal: 900, order_id: 4, item_id: 7 },
                   { quatity: 1, subtotal: 900, order_id: 5, item_id: 7 },
                   { quatity: 1, subtotal: 100, order_id: 5, item_id: 9 },
                   { quatity: 1, subtotal: 900, order_id: 6, item_id: 7 },
                   { quatity: 1, subtotal: 100, order_id: 6, item_id: 9 },
                   { quatity: 1, subtotal: 9700, order_id: 6, item_id: 2 }])

Item.create!({ title: 'Sajji', description: 'Rich in Carbs', price: 150, restaurant_id: 2 })
Category.create!({ name: 'Russian', restaurant_id: 2 })
ItemCategory.create!({ category_id: 6, item_id: 11 })
Order.create!({ user_id: 1, restaurant_id: 2, total: 150, status: 0 })
ItemOrder.create!({ quatity: 1, subtotal: 150, order_id: 7, item_id: 11 })
