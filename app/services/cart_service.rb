# cartindexservice
class CartService
  attr_reader :args
  def initialize(*args)
    if args.size == 2
      @check = args[0]
      @id = args[1]   
    elsif args.size == 3
      @remove = args[0]
      @item = args[1]
      @cart = args[2]
    end
  end

  def call
    if @check.blank?
      @carts = Cart.all.find_user_cart(@id)
      @total = Cart.calculate_total(@id)
    else
      @carts = @check
      @total = @check.sum(:subtotal)
    end
    [@carts, @total]
  end

  def update_cart
    ActiveModel::Type::Boolean.new.cast(@remove) ? remove_item(@item) : nil
    remove_item(@item) if @cart.quantity.zero?
    subtotal = @item.price * @cart.quantity
  end

  def remove_item(item)
    cart = Cart.find_by(item_id: item.id)
    Cart.delete(cart.id)
  end
end