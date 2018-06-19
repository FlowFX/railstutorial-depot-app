class StoreController < ApplicationController
  include Counter
  include CurrentCart

  before_action :set_cart
  before_action :get_counter, only: [:index]
  after_action  :increment_counter, only: [:index]

  def index
    @products = Product.order(:title)
  end
end
