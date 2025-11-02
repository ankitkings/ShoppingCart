class OrdersController < ApplicationController
  include ActionView::Helpers::NumberHelper

  before_action :authenticate_user!
  require 'prawn'
  require 'prawn/table'

  def index
    if current_user.admin?
      @orders = Order.all
    else
      @orders = current_user.orders
    end
  end

  def show
    @order = Order.find(params[:id])
  end

  def create
    cart = current_user.cart
    order = current_user.orders.create(status: 'Pending', total_amount: cart.cart_items.sum { |i| i.quantity * i.product.price })

    cart.cart_items.each do |item|
      order.order_items.create(product: item.product, quantity: item.quantity, price: item.product.price)
    end

    cart.cart_items.destroy_all
    redirect_to order_path(order), notice: "Order placed successfully."
  end

  def receipt
    @order = Order.find(params[:id])
    respond_to do |format|
      format.html
      format.pdf do
        pdf = generate_invoice_pdf(@order)
        send_data pdf.render,
                  filename: "order_#{@order.id}_invoice.pdf",
                  type: 'application/pdf',
                  disposition: 'attachment'
      end
    end
  end

  def update_status
    @order = Order.find(params[:id])
    if @order.update(status: params[:status])
      redirect_to orders_path, notice: "Order status updated."
    else
      redirect_to orders_path, alert: "Failed to update order status."
    end
  end

  private

  def generate_invoice_pdf(order)
    customer_name = order.user&.full_name || order.user&.email
    time_now = Time.current.strftime("%d-%m-%Y %I:%M %p")

    Prawn::Document.new do |pdf|
   
      pdf.text " Order Invoice", size: 26, style: :bold, align: :center
      pdf.move_down 10

      pdf.text "Customer: #{customer_name}", size: 12, style: :bold
      pdf.text "Downloaded at: #{time_now}", size: 12
      pdf.text "Order ID: #{order.id}", size: 12
      pdf.text "Status: #{order.status.capitalize}", size: 12
      pdf.move_down 20

      # 🧊 Stylish table
      data = [["Product", "Price", "Qty", "Total"]]
      order.order_items.each do |item|
        data << [
          item.product.title,
          "#{number_to_currency(item.product.price)}",
          item.quantity.to_s,
          "#{number_to_currency(item.product.price * item.quantity)}"
        ]
      end
      data << [
        { content: "", colspan: 2 },
        "<b>Total</b>",
        "<b>#{number_to_currency(order.total_amount)}</b>"
      ]

      pdf.table(data, header: true, width: pdf.bounds.width) do |t|
        t.row(0).font_style = :bold
        t.row(0).background_color = 'eeeeee'
        t.row(0).align = :center
        t.header = true

        t.cells.style do |cell|
          cell.border_width = 0.5
          cell.border_color = 'cccccc'
          cell.padding = [8, 12, 8, 12]
          cell.inline_format = true
        end

        t.columns(1..-1).align = :center
      end

      pdf.move_down 30
      pdf.text " Thank you for shopping with us!", align: :center, style: :italic
    end
  end


end
