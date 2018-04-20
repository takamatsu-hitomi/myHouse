require 'test_helper'

# 継承元をActionDispatch::IntegrationTestにした方が良さそうだったが
# postとかputのあたりが全く動かず調べても不明なのでActionController::TestCaseのままにする
class ProductsControllerTest < ActionController::TestCase
  setup do
    @product = products(:one)
    @update = {
      title:        'Lorem Ipsum',
      description:  'papipupepo',
      image_url:    'ruby.jpg',
      price:        19.95
    }
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:products)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create product" do
    assert_difference('Product.count') do
      post :create, params: {product: @update}
    end
    assert_redirected_to product_path(assigns(:product))
  end

  test "should update product" do
    put :update, params: {id: @product.to_param, product: @update}
    
    assert_redirected_to product_path(assigns(:product))
  end

end
