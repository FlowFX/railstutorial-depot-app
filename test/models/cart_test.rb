require 'test_helper'

class CartTest < ActiveSupport::TestCase
  fixtures :products

  def new_cart
    Cart.new
  end

  test 'adding a product adds a line item' do
    cart = new_cart
    product = products(:python)

    cart.add_product(product)

    assert cart.valid?
    assert_equal cart.line_items.length, 1
    assert_equal cart.line_items.last.product_price, product.price
  end

  test 'adding a product twice results in only one line item' do
    cart = new_cart
    product = products(:ruby)

    cart.add_product(product)
    cart.save
    cart.add_product(product)
    cart.save

    assert cart.valid?
    assert_equal 1, cart.line_items.length
  end
end
