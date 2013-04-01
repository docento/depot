class ApplicationController < ActionController::Base
  protect_from_forgery

  private

    def current_cart
        Cart.find(session[:cart_id])
    rescue ActiveRecord::RecordNotFound
        cart = Cart.create
        session[:cart_id] = cart.id
        cart
    end

    def count_store_controller
        if session[:store_count].nil?
            session[:store_count] = 1
        else
            session[:store_count] += 1
        end

        session[:store_count]
    end

    def clear_store_counter
        session[:store_count] = 0
    end
end
