require 'test_helper'

class SearchControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get search_show_url
    assert_response :success
  end

  test "should get confirm" do
    get search_confirm_url
    assert_response :success
  end

  test "should get results" do
    get search_results_url
    assert_response :success
  end

  test "should get sign_up" do
    get search_sign_up_url
    assert_response :success
  end

  test "should get next_steps" do
    get search_next_steps_url
    assert_response :success
  end

end
