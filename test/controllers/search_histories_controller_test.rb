require 'test_helper'

class SearchHistoriesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get search_histories_index_url
    assert_response :success
  end

end
