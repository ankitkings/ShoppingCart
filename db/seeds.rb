# Clear old data
OrderItem.destroy_all
Order.destroy_all
CartItem.destroy_all
Cart.destroy_all
Product.destroy_all
Category.destroy_all
User.destroy_all

# Create a user
user = User.create!(
  email: "test@example.com",
  password: "password",
  password_confirmation: "password"
)

puts "User created: #{user.email} / password"

# Create categories
categories = ["Electronics", "Clothing", "Books", "Furniture"].map do |name|
  Category.create!(name: name)
end

puts "Created #{categories.size} categories."

image_files = {
  "Electronics" => "laptop.jpeg",
  "Clothing" => "tshirt.jpeg",
  "Books" => "book.jpeg",
  "Furniture" => "chair.jpeg"
}

# Create products with images
30.times do
  category = categories.sample
  product = Product.create!(
    title: Faker::Commerce.product_name,
    description: Faker::Lorem.paragraph(sentence_count: 3),
    price: Faker::Commerce.price(range: 100.0..1000.0),
    category: category
  )

  image_path = Rails.root.join("app/assets/images/seed_products/#{image_files[category.name]}")
  product.image.attach(io: File.open(image_path), filename: image_files[category.name])

  puts "Product created: #{product.title} with image #{image_files[category.name]}"
end

# Create cart and cart_items
cart = Cart.create!(user: user)

3.times do
  product = Product.all.sample
  CartItem.create!(
    cart: cart,
    product: product,
    quantity: rand(1..3)
  )
end

puts "Cart with 3 items created."

# Create an order
order = Order.create!(
  user: user,
  status: "placed",
  total_amount: cart.cart_items.sum { |item| item.quantity * item.product.price }
)

cart.cart_items.each do |item|
  OrderItem.create!(
    order: order,
    product: item.product,
    quantity: item.quantity,
    price: item.product.price
  )
end

puts "Order placed with #{order.order_items.count} items."
