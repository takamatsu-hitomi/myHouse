class StoreController < ApplicationController
	skip_before_action :authorize
  def index
  	if params[:set_locale]
  		redirect_to store_path(locale: params[:set_locale])
  	else
	  	# order () 並び替えの関数
	  	@products = Product.order(:title)
	  	@cart = current_cart
	  end
	end
end
