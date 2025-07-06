class Product < ApplicationRecord
  belongs_to :category
  has_many :cart_items
  has_one_attached :image
end
