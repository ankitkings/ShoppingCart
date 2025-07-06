class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy

  after_create :reduce_stock

  STATUSES = ["Pending", "Processing", "Shipped", "Delivered"]

  validates :status, inclusion: { in: STATUSES }

   private

  def reduce_stock
    order_items.each do |item|
      product = item.product
      product.update(stock: product.stock - item.quantity) if product.stock.present?
    end
  end

end
