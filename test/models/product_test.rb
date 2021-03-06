require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  fixtures :products

  test 'product attributes must not be empty' do
    product = Product.new
    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:price].any?
    assert product.errors[:image_url].any?
  end

  test 'product price must be positive' do
    # GIVEN a product
    product = Product.new(title:       'My Book Title',
                          description: 'YYY',
                          image_url:  'zzz.jpg')

    # WHEN it's price is negative
    product.price = -1
    # THEN it's not a valid product.
    assert product.invalid?
    assert_equal ['must be greater than or equal to 0.01'], product.errors[:price]

    # WHEN it's price is zero
    product.price = 0
    # THEN it's not a valid product.
    assert product.invalid?
    assert_equal ['must be greater than or equal to 0.01'], product.errors[:price]

    # WHEN it's price is positive
    product.price = 1
    # THEN it's a valid product.
    assert product.valid?
  end

  def new_product(image_url)
    Product.new(title:       'My Book Title',
                description: 'yyy',
                price:       1,
                image_url:   image_url)
  end

  test 'image url' do
    ok = %w{ fred.gif fred.jpg fred.png FRED.JPG FRED.Jpg http://a.b.c/x/y/z/fred.gif }
    bad = %w{ fred.doc fred.gif/more fred.gif.more }

    ok.each do |name|
      assert new_product(name).valid?, "#{name} shouldn't be invalid"
    end

    bad.each do |name|
      assert new_product(name).invalid?, "#{name} shouldn't be valid"
    end
  end

  test 'product is not valid without a unique title' do
    product = Product.new(title:       products(:ruby).title,
                          description: 'yyy',
                          price:       1,
                          image_url:   'fred.gif')
    assert product.invalid?
    assert_equal [I18n.translate('errors.messages.taken')], product.errors[:title]
  end

  test 'product title should be at least 10 characters long' do
    product = products(:ruby)
    product.title = '123456789'
    assert product.invalid?
    assert_equal ['Get a grip on yourself!'], product.errors[:title]
  end
end
