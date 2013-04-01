class StoreController < ApplicationController
  def index
    @counted = count_store_controller
    @products = Product.order(:title)
  end
end
