class CartsController < ApplicationController
  before_action :authenticate_user!

  def show
    @cart = current_user.cart || current_user.create_cart
  end

  def add
    @cart = current_user.cart || current_user.create_cart
    product = Product.find(params[:product_id])
    item = @cart.cart_items.find_or_initialize_by(product: product)
    item.quantity ||= 0
    item.quantity += 1
    item.save
    redirect_to cart_path, notice: "#{product.title} added to cart."
  end

  def remove
    @cart = current_user.cart
    item = @cart.cart_items.find_by(product_id: params[:product_id])
    item.destroy if item
    redirect_to cart_path, notice: "Item removed from cart."
  end
end
# This controller manages the shopping cart functionality, allowing users to view their cart,
# add products to it, and remove products from it. It uses the current user's cart or creates a new one if it doesn't exist.
# The `add` action finds or initializes a cart item for the specified product and increments its quantity.
# The `remove` action finds the cart item by product ID and removes it from the cart.
# The `show` action displays the current user's cart, creating one if it doesn't exist.
# The controller ensures that only authenticated users can access these actions by using the `before_action :authenticate_user!` filter.
# The cart is associated with the user through a one-to-one relationship, and cart items are associated with both the cart and the product.
# The controller provides feedback to the user through flash notices when items are added or removed from the cart.
# The `current_user` method is used to access the currently logged-in user,
# and the `create_cart` method is called to create a new cart if the user doesn't have one.
# The `redirect_to` method is used to navigate back to the cart page after performing actions, providing a seamless user experience.
# The controller is designed to be simple and effective for managing a shopping cart in an e-commerce application.