require 'test_helper'

class UserStoriesTest < ActionDispatch::IntegrationTest
	fixtures :products

	#Replace this with your real tests.
	test "buying product" do
		LineItem.delete_all
		Order.delete_all
		ruby_book = products(:ruby)

		# ユーザーがインデックスページを訪れる
		get "/"
		assert_response :success
		assert_template "index"

		post '/line_items', params:{product_id: ruby_book.id},xhr:true
		#xml_http_request :post, '/line_items', product_id: ruby_book.id
		assert_response :success

		# 商品を選択してカートに入れる
		puts "カートに入れる"
		cart = Cart.find(session[:cart_id])
		assert_equal 1, cart.line_items.size
		assert_equal ruby_book, cart.line_items[0].product

		puts "チェックアウト"
		get "/orders/new"
		assert_response :success
		assert_template "new"

		post "/orders",
		params:{order: {name: "Dave Thomas",
			address: "123 The Street",
			email: "dave@example.com",
			pay_type: "現金"}}
			follow_redirect!
		
		assert_response :success

		puts "インデックスに戻る"
		#get "/"
		assert_template "index"
		cart = Cart.find(session[:cart_id])
		assert_equal 0, cart.line_items.size

		puts "データベースの確認"
		#データベースを参照し、注文とそれに対応する品目が作成されていること、
		#また適切なことを確認する
		orders = Order.all
		assert_equal 1, orders.size
		order = orders[0]

		assert_equal "Dave Thomas", order.name
		assert_equal "123 The Street", order.address
		assert_equal "dave@example.com", order.email
		assert_equal "現金", order.pay_type

		assert_equal 1, order.line_items.size
		line_item = order.line_items[0]

		assert_equal ruby_book.title, line_item.product.title
		assert_equal ruby_book.description, line_item.product.description
		assert_equal ruby_book.image_url, line_item.product.image_url
		assert_equal ruby_book.price, line_item.product.price

		# メール自体のアドレスと件名が正しいこと
		puts "メールのチェック"
		mail = ActionMailer::Base.deliveries.last

		assert_equal ["dave@example.com"], mail.to
		assert_equal 'Sam Ruby <depot@example.com>', mail[:from].value
		assert_equal "Pragmatic Store Order Confirmation", mail.subject
	end
end

