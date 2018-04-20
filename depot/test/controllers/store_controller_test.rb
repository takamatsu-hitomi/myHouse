require 'test_helper'

class StoreControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get store_index_url
    assert_response :success
  end

  test "markup needed for store.coffee is in place" do
  	get store_index_url
  	assert_select '.store .entry > img', 3
  	assert_select '.entry input[type=submit]', 3
  end

end
