class LineItem < ApplicationRecord
	# carts, productテーブルへの逆方向のリンク指定

	# optional:trueをつけないと.saveで失敗するようになった
	# https://teratail.com/questions/65278
	belongs_to :order, optional:true
	belongs_to :product, optional:true
	belongs_to :cart, optional:true

	def total_price
		product.price * quantity
	end
end
